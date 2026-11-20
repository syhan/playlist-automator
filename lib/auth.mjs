/**
 * 自己实现 accessToken 续期。
 *
 * 为什么需要：ncm-cli 0.1.7 的自动续期有 bug —— 它确实调用了
 *   GET /openapi/music/basic/user/oauth2/token/refresh/v2
 * 并且服务端返回了新的 accessToken/refreshToken，但响应里的字段叫 `expiresTime`，
 * 而 CLI 读的是 `expireTime`，于是判定失败 → 退回二维码登录，并把已有的实名 token 抹掉。
 * 结果就是：无人值守跑一天之后必然掉登录。
 *
 * 这里按 CLI 自己的协议重放这次刷新（同样的签名串），成功则写回 tokens.enc.json。
 *
 * 签名串格式（抓包确认，参数按字母序拼接，不含 sign）：
 *   accessToken=<token>&appId=<appId>&bizContent=<json>&device=<json>&signType=RSA_SHA256&timestamp=<ms>
 * 签名算法：RSA-SHA256 + base64
 */

import crypto from 'node:crypto'
import os from 'node:os'
import { CLI_VERSION } from './keystore.mjs'

const API_BASE = 'https://openncm.music.163.com'
const REFRESH_PATH = '/openapi/music/basic/user/oauth2/token/refresh/v2'

const cap = (s) => s.charAt(0).toUpperCase() + s.slice(1)

/** credentials 里存的是裸 base64（PKCS#8 DER），crypto 需要 PEM，这里补齐头尾 */
export function toPem(key) {
  if (!key) throw new Error('privateKey 为空')
  if (key.includes('-----BEGIN')) return key
  const body = key.replace(/\s+/g, '').match(/.{1,64}/g).join('\n')
  return `-----BEGIN PRIVATE KEY-----\n${body}\n-----END PRIVATE KEY-----\n`
}

export async function fetchClientIp({ timeout = 8000 } = {}) {
  try {
    const res = await fetch('https://api.ipify.org?format=json', { signal: AbortSignal.timeout(timeout) })
    const json = await res.json()
    return json.ip
  } catch {
    return '127.0.0.1' // 服务端不校验该字段（实测伪造 8.8.8.8 也能通过）
  }
}

export function buildDevice(deviceId, clientIp) {
  return {
    deviceType: 'openapi',
    os: 'ncmcli',
    appVer: CLI_VERSION,
    channel: 'ncmcli',
    model: `${cap(os.platform())}_${os.arch()}_cli`,
    brand: 'ncmcli',
    osVer: os.release(),
    clientIp,
    deviceId,
  }
}

export function sign(accessToken, appId, bizContent, device, privateKey, timestamp = Date.now()) {
  // 参数按字母序：accessToken, appId, bizContent, device, signType, timestamp
  const canonical = [
    `accessToken=${accessToken}`,
    `appId=${appId}`,
    `bizContent=${JSON.stringify(bizContent)}`,
    `device=${JSON.stringify(device)}`,
    `signType=RSA_SHA256`,
    `timestamp=${timestamp}`,
  ].join('&')
  const signature = crypto.createSign('RSA-SHA256').update(canonical).sign(toPem(privateKey), 'base64')
  return { canonical, signature, timestamp }
}

/** 用 refreshToken 换新 token。返回 { accessToken, refreshToken, expiresTime } */
export async function refreshNamedToken({ appId, privateKey, deviceId, refreshToken, accessToken }) {
  const clientIp = await fetchClientIp()
  const device = buildDevice(deviceId, clientIp)
  const bizContent = { clientId: appId, clientSecret: '', refreshToken }
  const { signature, timestamp } = sign(accessToken ?? '', appId, bizContent, device, privateKey)

  // 参数顺序与 CLI 保持一致（签名只覆盖 canonical string，顺序其实无关，但保持一致便于排查）
  const qs = [
    ['appId', appId],
    ['signType', 'RSA_SHA256'],
    ['timestamp', String(timestamp)],
    ['device', JSON.stringify(device)],
    ['bizContent', JSON.stringify(bizContent)],
    ['accessToken', accessToken ?? ''],
    ['sign', signature],
  ]
    .map(([k, v]) => `${k}=${encodeURIComponent(v)}`)
    .join('&')

  const res = await fetch(`${API_BASE}${REFRESH_PATH}?${qs}`, {
    headers: { Accept: 'application/json', 'User-Agent': 'ncm-cli' },
    signal: AbortSignal.timeout(20000),
  })
  const text = await res.text()
  let json
  try {
    json = JSON.parse(text)
  } catch {
    throw new Error(`续期响应不是 JSON（HTTP ${res.status}）: ${text.slice(0, 160)}`)
  }
  if (json.code !== 200 || !json.data?.accessToken) {
    throw new Error(`续期失败: code=${json.code} ${json.message ?? json.msg ?? ''}`.trim())
  }
  return json.data
}

/**
 * 确保本地 token 可用：剩余时间不足 marginMs 就用 refreshToken 续一次。
 * 返回 { refreshed, expiresAt }
 */
export async function ensureSession({ credentials, tokens, marginMs = 10 * 60 * 1000, log = console.log }) {
  const now = Date.now()
  const expiresAt = tokens.namedTokenExpireAt ?? 0
  if (tokens.namedToken && expiresAt - now > marginMs) {
    return { refreshed: false, expiresAt }
  }
  if (!tokens.namedRefreshToken) {
    throw new Error('没有可用的 refreshToken：请先在本地执行 `ncm-cli login` 扫码，然后重新导出 tokens.enc.json')
  }
  log('  accessToken 已过期或即将过期 → 用 refreshToken 续期…')
  const data = await refreshNamedToken({
    appId: credentials.appId,
    privateKey: credentials.privateKey,
    deviceId: credentials.deviceId,
    refreshToken: tokens.namedRefreshToken,
    accessToken: tokens.namedToken,
  })
  const seconds = Number(data.expiresTime ?? data.expireTime ?? 86400)
  return {
    refreshed: true,
    expiresAt: now + seconds * 1000,
    tokens: {
      ...tokens,
      namedToken: data.accessToken,
      namedRefreshToken: data.refreshToken ?? tokens.namedRefreshToken,
      namedTokenExpireAt: now + seconds * 1000,
    },
  }
}
