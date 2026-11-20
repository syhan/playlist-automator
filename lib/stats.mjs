/**
 * 统计产物（取代 statistics.sh / stats.sh）。
 * 输出仍是 gh-pages 上那几个文本文件，外加可选的 sqlite。
 */

import fs from 'node:fs'
import path from 'node:path'
import { spawn } from 'node:child_process'

const pad = (n, w = 7) => String(n).padStart(w)
const byCount = (a, b) => b[1] - a[1] || String(a[0]).localeCompare(String(b[0]))

export async function writeStats(workDir, days, agg, { nicknames, sqlite = false, log = console.log } = {}) {
  const out = (name, content) => {
    fs.writeFileSync(path.join(workDir, name), content)
    log(`  ✓ ${name}`)
  }

  // artists / albums / tracks：沿用 uniq -c 的 "  次数 键 名称" 格式
  out('artists', [...agg.artists].sort(byCount).map(([name, c]) => `${pad(c)} ${name}`).join('\n') + '\n')
  out('albums', [...agg.albums].sort(byCount).map(([name, c]) => `${pad(c)} ${name}`).join('\n') + '\n')
  out(
    'tracks',
    [...agg.tracks.values()]
      .sort((a, b) => b.count - a.count || a.id - b.id)
      .map((t) => `${pad(t.count)} ${t.id} ${t.name}`)
      .join('\n') + '\n',
  )

  // contributors：uid 次数 昵称（旧格式来自 join，无填充）
  const contributors = [...agg.contributors]
    .sort((a, b) => b[1] - a[1] || a[0] - b[0])
    .map(([uid, count]) => [uid, count])
  const names = new Map()
  for (const [uid] of contributors) names.set(uid, await nicknames.resolve(uid))
  nicknames.flush?.()
  out('contributors', contributors.map(([uid, c]) => `${uid} ${c} ${names.get(uid)}`).join('\n') + '\n')

  // 交叉表（旧脚本里是 join 的产物，保持一样的两列）
  const trackContributor = []
  const contribAlbum = []
  const trackAlbum = []
  for (const { playlist } of days) {
    const songById = new Map((playlist.tracks ?? []).map((t) => [t.id, t]))
    for (const tid of playlist.trackIds ?? []) {
      const song = songById.get(tid.id)
      if (!song) continue
      if (tid.uid != null) trackContributor.push(`${tid.id} ${tid.uid}`)
      if (song.al?.name) {
        trackAlbum.push(`${tid.id} ${song.al.name}`)
        if (tid.uid != null) contribAlbum.push(`${song.al.name} ${tid.uid}`)
      }
    }
  }
  const uniqSorted = (arr) => [...new Set(arr)].sort().join('\n') + '\n'
  out('track_contributor', uniqSorted(trackContributor))
  out('track_album', uniqSorted(trackAlbum))
  out('contributor_album', uniqSorted(contribAlbum))

  writeSongCsv(workDir, agg, out)

  if (sqlite) await buildSqlite(workDir, days, agg, names, log)
}

/** 取代 stats_songs.py：按**歌名**聚合（同名不同版本会合并，与旧 CSV 口径一致） */
function writeSongCsv(workDir, agg, out) {
  const byName = new Map()
  for (const t of agg.tracks.values()) {
    const name = (t.name ?? '').trim()
    if (!name) continue
    const entry = byName.get(name) ?? { count: 0, artists: new Set() }
    entry.count += t.count
    const artistStr = (t.artists ?? []).filter(Boolean).join(' / ')
    if (artistStr) entry.artists.add(artistStr)
    byName.set(name, entry)
  }
  const rows = [...byName]
    .sort((a, b) => b[1].count - a[1].count || a[0].localeCompare(b[0]))
    .map(([name, e]) => `${escapeCsv(name)},${escapeCsv([...e.artists].sort().join('; '))},${e.count}`)
  // 旧脚本用 utf-8-sig，保留 BOM 以免 Excel 乱码
  out('song_counts.csv', '\ufeff' + '歌名,歌手,出现次数\n' + rows.join('\n') + '\n')
}

const escapeCsv = (s) => (/[",\n]/.test(s) ? `"${s.replace(/"/g, '""')}"` : s)

/** 可选：重建 stats.db（等价于旧 stats.sh），供 dataviz.R 使用 */
async function buildSqlite(workDir, days, agg, names, log) {
  const esc = (s) => String(s ?? '').replace(/'/g, "''")
  const sql = [
    'CREATE TABLE contributors (UID INTEGER PRIMARY KEY, name TEXT);',
    'CREATE TABLE contributions (UID INTEGER, TRACK_ID INTEGER, DAY DATE);',
    'CREATE TABLE tracks (TRACK_ID INTEGER, ALBUM_ID INTEGER, ARTIST TEXT, NAME TEXT);',
    'CREATE TABLE albums (ALBUM_ID INTEGER PRIMARY KEY, NAME TEXT);',
    'CREATE TABLE history (DAY DATE, THEME TEXT);',
  ]
  for (const [uid, name] of names) sql.push(`INSERT INTO contributors VALUES (${uid}, '${esc(name)}');`)

  const seenTrack = new Set()
  const seenAlbum = new Set()
  for (const { day, playlist } of days) {
    const songById = new Map((playlist.tracks ?? []).map((t) => [t.id, t]))
    for (const tid of playlist.trackIds ?? []) {
      const song = songById.get(tid.id)
      if (!song) continue
      if (tid.uid != null) sql.push(`INSERT INTO contributions VALUES (${tid.uid}, ${tid.id}, '${day}');`)
      if (!seenTrack.has(tid.id)) {
        seenTrack.add(tid.id)
        sql.push(
          `INSERT INTO tracks VALUES (${tid.id}, ${song.al?.id ?? 0}, '${esc((song.ar ?? []).map((a) => a.name).join('/'))}', '${esc(song.name)}');`,
        )
      }
      if (song.al?.id != null && !seenAlbum.has(song.al.id)) {
        seenAlbum.add(song.al.id)
        sql.push(`INSERT INTO albums VALUES (${song.al.id}, '${esc(song.al.name)}');`)
      }
    }
    sql.push(`INSERT INTO history VALUES ('${day}', '${esc((playlist.description ?? '').slice(0, 90))}');`)
  }

  const schemaFile = path.join(workDir, 'schema.sql')
  fs.writeFileSync(schemaFile, sql.join('\n') + '\n')
  const dbFile = path.join(workDir, 'stats.db')
  fs.rmSync(dbFile, { force: true })
  await new Promise((resolve, reject) => {
    const p = spawn('sqlite3', [dbFile], { stdio: ['pipe', 'ignore', 'pipe'] })
    let err = ''
    p.stderr.on('data', (d) => (err += d))
    p.on('error', reject)
    p.on('close', (code) =>
      code === 0 ? resolve() : reject(new Error(`sqlite3 退出码 ${code}: ${err.slice(0, 300)}`)),
    )
    p.stdin.end(sql.join('\n') + '\n')
  })
  log(`  ✓ stats.db（${seenTrack.size} 首 / ${seenAlbum.size} 张专辑）`)
}
