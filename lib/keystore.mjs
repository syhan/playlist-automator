/**
 * ncm-cli 的凭证存储（只读/写本地文件，不联网）。
 *
 * 格式（逆向自 ncm-cli 0.1.7）：
 *   ~/.netease_mcp_device.json        明文 { deviceId, createdAt }
 *   ~/.config/ncm-cli/credentials.enc.json  {"iv","data"}  AES-256-CBC，key = sha256(deviceId)
 *   ~/.config/ncm-cli/tokens.enc.json       同上
 *
 * 注意：密钥就是 sha256(deviceId)，而 deviceId 明文躺在 home 下 —— 加密只是混淆。
 * 所以「迁移凭证」= 一起搬 3 个文件，缺 device 文件就解不开。
 */

import crypto from 'node:crypto'
import fs from 'node:fs'
import os from 'node:os'
import path from 'node:path'

export const CLI_VERSION = '0.1.7'

export function paths(home = os.homedir()) {
  const configDir = path.join(home, '.config', 'ncm-cli')
  return {
    home,
    configDir,
    device: path.join(home, '.netease_mcp_device.json'),
    credentials: path.join(configDir, 'credentials.enc.json'),
    tokens: path.join(configDir, 'tokens.enc.json'),
  }
}

function keyOf(deviceId) {
  return crypto.createHash('sha256').update(deviceId).digest()
}

export function readDevice(home) {
  const p = paths(home)
  if (!fs.existsSync(p.device)) {
    throw new Error(`缺少 ${p.device}（没有它无法解密凭证；请连同该文件一起迁移）`)
  }
  return JSON.parse(fs.readFileSync(p.device, 'utf8'))
}

export function readEnc(file, deviceId) {
  const { iv, data } = JSON.parse(fs.readFileSync(file, 'utf8'))
  const d = crypto.createDecipheriv('aes-256-cbc', keyOf(deviceId), Buffer.from(iv, 'hex'))
  return JSON.parse(Buffer.concat([d.update(Buffer.from(data, 'hex')), d.final()]).toString('utf8'))
}

export function writeEnc(file, obj, deviceId) {
  const iv = crypto.randomBytes(16)
  const c = crypto.createCipheriv('aes-256-cbc', keyOf(deviceId), iv)
  const data = Buffer.concat([c.update(JSON.stringify(obj)), c.final()])
  fs.mkdirSync(path.dirname(file), { recursive: true })
  fs.writeFileSync(file, JSON.stringify({ iv: iv.toString('hex'), data: data.toString('hex') }), { mode: 0o600 })
}

export function loadCredentials(home) {
  const p = paths(home)
  const device = readDevice(home)
  return { ...readEnc(p.credentials, device.deviceId), deviceId: device.deviceId, paths: p }
}

export function loadTokens(home) {
  const p = paths(home)
  const device = readDevice(home)
  if (!fs.existsSync(p.tokens)) return { tokens: {}, deviceId: device.deviceId, paths: p }
  return { tokens: readEnc(p.tokens, device.deviceId), deviceId: device.deviceId, paths: p }
}

export function saveTokens(home, tokens) {
  const p = paths(home)
  const device = readDevice(home)
  writeEnc(p.tokens, tokens, device.deviceId)
  return p.tokens
}
