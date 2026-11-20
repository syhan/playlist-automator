/**
 * 历史快照聚合：取代原来的 statistics.sh / stats.sh 里的 jq 大管道。
 */

import fs from 'node:fs'
import path from 'node:path'

/** 读取 <dataDir>/*.json，返回 [{ day, playlist }]，坏文件会被跳过并记录 */
export function loadSnapshots(dataDir) {
  const days = []
  const skipped = []
  if (!fs.existsSync(dataDir)) return { days, skipped }

  for (const fname of fs.readdirSync(dataDir).sort()) {
    if (!fname.endsWith('.json')) continue
    const day = fname.replace(/\.json$/, '')
    const file = path.join(dataDir, fname)
    let raw
    try {
      raw = fs.readFileSync(file, 'utf8')
    } catch (err) {
      skipped.push({ day, reason: err.message })
      continue
    }
    let json
    try {
      json = JSON.parse(raw)
    } catch {
      // 历史上 Vercel 的 500/超时被当成 JSON 存了下来
      skipped.push({ day, reason: `非 JSON（${raw.slice(0, 40).replace(/\s+/g, ' ')}…）` })
      continue
    }
    if (!json.playlist) {
      skipped.push({ day, reason: `缺少 playlist 字段（code=${json.code}）` })
      continue
    }
    days.push({ day, playlist: json.playlist })
  }
  return { days, skipped }
}

/** 聚合：歌曲频次、贡献者、艺人、专辑 */
export function aggregate(days) {
  const tracks = new Map() // songId -> { id, name, artists[], album, count, uids:Set, firstDay, lastDay }
  const contributors = new Map() // uid -> count
  const artists = new Map()
  const albums = new Map()
  const history = [] // { day, theme }

  for (const { day, playlist } of days) {
    const trackIds = playlist.trackIds ?? []
    const songById = new Map((playlist.tracks ?? []).map((t) => [t.id, t]))

    for (const tid of trackIds) {
      const song = songById.get(tid.id)
      if (!song) continue
      const artistNames = (song.ar ?? []).map((a) => a.name).filter(Boolean)
      const albumName = song.al?.name ?? null

      const rec =
        tracks.get(tid.id) ??
        {
          id: tid.id,
          name: song.name,
          artists: artistNames,
          album: albumName,
          picUrl: song.al?.picUrl ?? null,
          count: 0,
          uids: new Set(),
          firstDay: day,
          lastDay: day,
        }
      rec.count += 1
      rec.lastDay = day
      if (!rec.name && song.name) rec.name = song.name
      if (tid.uid != null) rec.uids.add(tid.uid)
      tracks.set(tid.id, rec)

      if (tid.uid != null) contributors.set(tid.uid, (contributors.get(tid.uid) ?? 0) + 1)
      for (const a of artistNames) artists.set(a, (artists.get(a) ?? 0) + 1)
      if (albumName) albums.set(albumName, (albums.get(albumName) ?? 0) + 1)
    }

    history.push({ day, theme: parseTheme(playlist.description).title })
  }

  return { tracks, contributors, artists, albums, history }
}

/** 按出现次数排序，返回前 n 首 */
export function topTracks(agg, n) {
  return [...agg.tracks.values()].sort((a, b) => b.count - a.count || a.id - b.id).slice(0, n)
}

/**
 * 解析歌单描述。历史格式：
 *   "2026/11/20 主题：爱笑的天使# 吼吼"
 *   "2021/08/13 主题：纯音乐"
 * 返回 { date, title, by }
 */
export function parseTheme(description) {
  const raw = (description ?? '').trim()
  if (!raw) return { date: null, title: '', by: '' }
  const dateMatch = raw.match(/^(\d{4})\/(\d{2})\/(\d{2})/)
  const date = dateMatch ? `${dateMatch[1]}-${dateMatch[2]}-${dateMatch[3]}` : null
  let rest = date ? raw.slice(dateMatch[0].length).trim() : raw
  rest = rest.replace(/^主题[：:]\s*/, '')
  const hashIdx = rest.indexOf('#')
  const title = (hashIdx >= 0 ? rest.slice(0, hashIdx) : rest).trim()
  const by = hashIdx >= 0 ? rest.slice(hashIdx + 1).trim() : ''
  return { date, title, by }
}

/** 写 "  次数 id 名称" 形式的计数文件（沿用旧格式） */
export function writeCountFile(file, entries) {
  const lines = [...entries]
    .sort((a, b) => b[1] - a[1] || String(a[0]).localeCompare(String(b[0])))
    .map(([key, count]) => `${String(count).padStart(7)} ${key}`)
  fs.writeFileSync(file, lines.join('\n') + '\n')
}
