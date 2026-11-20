/**
 * ncm-cli 封装：负责所有**写操作**（以及需要加密 ID 的读操作）。
 *
 * 约定：
 *   - 一律带 --output json，stdout 必须是单个 JSON；
 *   - 任何 code !== 200 / success === false 都抛异常（旧脚本静默失败了一年的教训）；
 *   - 分页读取合并成数组。
 */

import { execFile } from 'node:child_process'

export const NCM_CLI = process.env.NCM_CLI || 'ncm-cli'

const sleep = (ms) => new Promise((r) => setTimeout(r, ms))

/**
 * 调一次 ncm-cli，返回解析后的 JSON。
 *
 * 重试原因：ncm-cli 的动态子命令（playlist/user/search…）是启动后异步拉
 * `/openapi/v1/ncm/cli/manifest` 注册的。在慢机器（如 GitHub runner）上，
 * commander 解析 argv 时 manifest 还没回来，就会报 `error: unknown command 'playlist'`
 * —— 但此时 API 请求其实已经在发了。所以这里对这类错误重试。
 */
export async function ncm(args, { timeout = 180000, retries = 4 } = {}) {
  for (let attempt = 1; ; attempt++) {
    try {
      return await ncmOnce(args, { timeout })
    } catch (err) {
      const flaky = /unknown command/i.test(err.message)
      if (!flaky || attempt >= retries) throw err
      await sleep(1200 * attempt)
    }
  }
}

async function ncmOnce(args, { timeout = 180000 } = {}) {
  const argv = [...args, '--output', 'json']
  const stdout = await new Promise((resolve, reject) => {
    execFile(NCM_CLI, argv, { timeout, maxBuffer: 64 * 1024 * 1024 }, (err, so, se) => {
      if (err) {
        reject(new Error(`ncm-cli ${args.slice(0, 2).join(' ')} 执行失败: ${err.message}\n${(se || so || '').slice(0, 400)}`))
      } else resolve(so)
    })
  })

  let json
  try {
    json = JSON.parse(stdout)
  } catch {
    throw new Error(`ncm-cli ${args.slice(0, 2).join(' ')} 输出不是 JSON: ${stdout.slice(0, 300)}`)
  }
  if (json.success === false) {
    throw new Error(`ncm-cli ${args.slice(0, 2).join(' ')} 失败: ${json.message ?? JSON.stringify(json).slice(0, 200)}`)
  }
  if (json.code !== undefined && json.code !== 200) {
    throw new Error(
      `ncm-cli ${args.slice(0, 2).join(' ')} 失败: code=${json.code} ${json.message ?? json.msg ?? ''}`,
    )
  }
  return json
}

/** 歌单元信息（不返回曲目） */
export async function playlistMeta(encryptedId) {
  const json = await ncm(['playlist', 'get', '--playlistId', encryptedId])
  return json.data
}

/** 歌单全部曲目（自动分页，每页 ≤500） */
export async function playlistTracks(encryptedId, { pageSize = 500, onPage } = {}) {
  const all = []
  for (let offset = 0; ; offset += pageSize) {
    const json = await ncm([
      'playlist', 'tracks',
      '--playlistId', encryptedId,
      '--limit', String(pageSize),
      '--offset', String(offset),
    ])
    const records = json.data?.records ?? json.data ?? []
    const arr = Array.isArray(records) ? records : []
    all.push(...arr)
    onPage?.({ offset, count: arr.length, total: all.length })
    if (arr.length < pageSize) break
    await sleep(300) // 温和一点，别触发风控
  }
  return all
}

export async function addTracks(encryptedId, songIds) {
  if (!songIds.length) return { skipped: true }
  return ncm(['playlist', 'add', '--playlistId', encryptedId, '--songIdList', JSON.stringify(songIds)])
}

export async function removeTracks(encryptedId, songIds) {
  if (!songIds.length) return { skipped: true }
  return ncm(['playlist', 'remove', '--playlistId', encryptedId, '--songIdList', JSON.stringify(songIds)])
}

export async function updateDesc(encryptedId, desc) {
  return ncm(['playlist', 'updateDesc', '--playlistId', encryptedId, '--desc', desc])
}

/** 调整歌单顺序（必须传歌单下**全部**歌曲，按目标顺序） */
export async function reorderTracks(encryptedId, songIds) {
  if (!songIds.length) return { skipped: true }
  return ncm(['playlist', 'reorder', '--playlistId', encryptedId, '--trackIds', JSON.stringify(songIds)])
}

/** 在歌单下发一级评论（resourceType 0 = 歌单，resourceId 用**数字** ID） */
export async function postPlaylistComment(numericId, content) {
  return ncm([
    'comment', 'post',
    '--resourceType', '0',
    '--resourceId', String(numericId),
    '--content', content,
  ])
}

/** 按关键词搜索歌曲，返回 records */
export async function searchSongs(keyword, limit = 10) {
  const json = await ncm(['search', 'song', '--keyword', keyword, '--limit', String(limit)])
  return json.data?.records ?? json.data ?? []
}

/** 登录态检查 */
export async function checkLogin() {
  return ncm(['login', '--check'])
}
