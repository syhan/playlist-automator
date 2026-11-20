/**
 * 匿名网易云 Web API 封装。
 *
 * 为什么不用 ncm-cli 做这件事：开放平台的 `playlist tracks` 不返回
 * `trackIds[].uid`（点歌人），而这是本项目的核心数据。匿名 Web 接口
 * 不需要登录、也不会过期，正好补上这个 gap。
 *
 * 已验证可用（无需 Cookie）：
 *   GET /api/v6/playlist/detail?id=<数字ID>&n=1000   → playlist.tracks / trackIds[].uid / .at
 *   GET /api/v1/user/detail/<uid>                    → profile.nickname
 */

import fs from 'node:fs'
import path from 'node:path'

const UA =
  'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) ' +
  'Chrome/120.0.0.0 Safari/537.36'
const WEB_BASE = 'https://music.163.com'

const sleep = (ms) => new Promise((r) => setTimeout(r, ms))

/**
 * GET + JSON。对网易的风控码（405/406 “操作频繁”）做退避重试。
 */
async function fetchJson(url, { retries = 4, timeout = 20000, baseDelay = 1500 } = {}) {
  let lastErr
  for (let attempt = 1; attempt <= retries; attempt++) {
    const ac = new AbortController()
    const timer = setTimeout(() => ac.abort(), timeout)
    try {
      const res = await fetch(url, {
        signal: ac.signal,
        headers: {
          'User-Agent': UA,
          Referer: `${WEB_BASE}/`,
          Accept: 'application/json, text/plain, */*',
        },
      })
      const text = await res.text()
      // 网易/Vercel 出错时会返回 HTML 或纯文本（历史上有 2 天就是这样被存进 _data 的）
      let json
      try {
        json = JSON.parse(text)
      } catch {
        throw new Error(`非 JSON 响应 (HTTP ${res.status}): ${text.slice(0, 120).replace(/\s+/g, ' ')}`)
      }
      if (!res.ok) throw new Error(`HTTP ${res.status}: ${text.slice(0, 120)}`)
      if (json.code === 405 || json.code === 406) {
        throw Object.assign(new Error(`${json.code} ${json.message ?? json.msg ?? '操作频繁'}`), {
          retryable: true,
        })
      }
      return json
    } catch (err) {
      lastErr = err
      if (attempt < retries) {
        // 风控码退避得更久；网络错误则快退
        await sleep(err.retryable ? baseDelay * attempt * 2 : 500 * attempt)
      }
    } finally {
      clearTimeout(timer)
    }
  }
  throw lastErr
}

/** 歌单快照：返回 { code, playlist: { name, description, tracks[], trackIds[] } } */
export async function fetchPlaylistDetail(numericId) {
  const json = await fetchJson(`${WEB_BASE}/api/v6/playlist/detail?id=${numericId}&n=1000`)
  if (json.code !== 200 || !json.playlist) {
    throw new Error(`歌单 ${numericId} 拉取失败: code=${json.code} ${json.message ?? json.msg ?? ''}`)
  }
  return json
}

/** UID → 用户资料（昵称等） */
export async function fetchUserDetail(uid) {
  const json = await fetchJson(`${WEB_BASE}/api/v1/user/detail/${uid}`)
  const profile = json.profile
  if (!profile) throw new Error(`用户 ${uid} 拉取失败: ${JSON.stringify(json).slice(0, 120)}`)
  return profile
}

/** 带本地缓存的 UID → 昵称解析器（缓存落在 <cacheDir>/nicknames.json） */
export function createNicknameResolver(cacheDir, { ttlMs = 30 * 24 * 3600 * 1000, minInterval = 900 } = {}) {
  const file = path.join(cacheDir, 'nicknames.json')
  let cache = {}
  try {
    cache = JSON.parse(fs.readFileSync(file, 'utf8'))
  } catch {
    cache = {}
  }
  let dirty = false
  let lastCall = 0
  const failed = []
  let fetched = 0
  let hits = 0

  return {
    async resolve(uid) {
      const key = String(uid)
      const hit = cache[key]
      if (hit?.name) {
        hits++
        return hit.name
      }
      try {
        // 串行 + 最小间隔：网易对 user/detail 限得很紧（405/406 操作频繁）
        const wait = minInterval - (Date.now() - lastCall)
        if (wait > 0) await sleep(wait)
        lastCall = Date.now()
        const profile = await fetchUserDetail(key)
        fetched++
        cache[key] = { name: profile.nickname, at: Date.now() }
        dirty = true
        return profile.nickname
      } catch (err) {
        failed.push(`${uid}: ${err.message}`)
        console.warn(`  ! 昵称解析失败 uid=${uid}: ${err.message}`)
        return `用户${uid}`
      }
    },
    flush() {
      if (dirty) {
        fs.mkdirSync(cacheDir, { recursive: true })
        fs.writeFileSync(file, JSON.stringify(cache, null, 2))
      }
      return { fetched, hits, failed: failed.length, failures: failed.slice(0, 5) }
    },
  }
}
