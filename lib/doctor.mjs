/**
 * 脏数据体检 & 修复。
 *
 * 历史遗留问题（都是旧管线造成的）：
 *   1. 快照不是 JSON —— Vercel 的 500/超时被当成响应存了下来（20230128 / 20241026）
 *   2. 空快照 —— 歌单为空却留下了文件（20211120~22），旧脚本本该 rm 掉
 *   3. tracks 与 trackIds 数量不符 —— API 只回了部分曲目详情，导致点歌人 uid 悬空
 *   4. 空文章 —— 上面的坏快照生成了 title 为空的 post
 *   5. 文章引用的封面图缺失
 *   6. 文件名日期与描述里的日期不一致 —— 历史时区 bug；描述日期可能是人工笔误，不做改名
 *
 * 用法：node automator.mjs doctor [--fix]
 */

import fs from 'node:fs'
import path from 'node:path'
import { buildCover } from './post.mjs'
import { fetchSongDetails } from './webapi.mjs'
import { parseTheme } from './aggregate.mjs'

const readJson = (file) => JSON.parse(fs.readFileSync(file, 'utf8'))

export async function doctor({ workDir, fix = false, log = console.log }) {
  const dataDir = path.join(workDir, '_data')
  const postsDir = path.join(workDir, '_posts')
  const imagesDir = path.join(workDir, 'images')
  const quarantineDir = path.join(workDir, '.quarantine')

  const report = {
    corrupt: [],
    empty: [],
    mismatched: [],
    emptyPosts: [],
    missingCovers: [],
    dateMismatch: 0,
    fixed: [],
  }

  if (!fs.existsSync(dataDir)) throw new Error(`找不到 ${dataDir}`)

  const days = []
  // ---- 1) 快照本体
  for (const fname of fs.readdirSync(dataDir).sort()) {
    if (!fname.endsWith('.json')) continue
    const day = fname.replace(/\.json$/, '')
    const file = path.join(dataDir, fname)

    let raw
    try {
      raw = fs.readFileSync(file, 'utf8')
    } catch {
      continue
    }

    let json
    try {
      json = JSON.parse(raw)
    } catch {
      report.corrupt.push({ day, file, why: raw.slice(0, 48).replace(/\s+/g, ' ') })
      continue
    }
    if (!json.playlist) {
      report.corrupt.push({ day, file, why: `缺少 playlist（code=${json.code}）` })
      continue
    }

    const p = json.playlist
    const tracks = p.tracks ?? []
    const trackIds = p.trackIds ?? []
    if (!tracks.length && !trackIds.length) {
      report.empty.push({ day, file })
      continue
    }

    // ---- 3) 悬空 trackId → 补全曲目详情
    const trackSet = new Set(tracks.map((t) => t.id))
    const dangling = trackIds.filter((t) => !trackSet.has(t.id))
    if (dangling.length) {
      report.mismatched.push({ day, file, tracks: tracks.length, trackIds: trackIds.length, dangling: dangling.length })
      if (fix) {
        const songs = await fetchSongDetails(dangling.map((t) => t.id))
        const byId = new Map(songs.map((s) => [s.id, s]))
        const recovered = dangling.filter((t) => byId.has(t.id)).map((t) => byId.get(t.id))
        if (recovered.length) {
          p.tracks = [...tracks, ...recovered]
          report.fixed.push(`${day}: 补全 ${recovered.length}/${dangling.length} 首曲目详情`)
        }
        const still = dangling.filter((t) => !byId.has(t.id))
        if (still.length) {
          const drop = new Set(still.map((t) => t.id))
          p.trackIds = trackIds.filter((t) => !drop.has(t.id))
          p.trackCount = p.tracks.length
          report.fixed.push(`${day}: 裁剪 ${still.length} 个无法解析的 trackId`)
        }
        fs.writeFileSync(file, JSON.stringify(json))
      }
    }

    // ---- 6) 文件名与描述日期
    const meta = parseTheme(p.description)
    if (meta.date && meta.date.replace(/-/g, '') !== day) report.dateMismatch++

    days.push({ day, playlist: p })
  }

  // ---- 4) 空文章
  const validDays = new Set(days.map((d) => d.day))
  const postFiles = fs.existsSync(postsDir) ? fs.readdirSync(postsDir).filter((f) => f.endsWith('.md')) : []
  const postTexts = new Map()
  for (const fname of postFiles) postTexts.set(fname, fs.readFileSync(path.join(postsDir, fname), 'utf8'))

  const toDelete = []
  for (const fname of postFiles) {
    const text = postTexts.get(fname)
    const day = fname.slice(0, 10).replace(/-/g, '')
    const emptyTitle = /^title:\s*("")?\s*$/m.test(text)
    const noRows = !text.split('\n').some((l) => l.startsWith('|') && l.length > 3)
    if ((emptyTitle || noRows) && !validDays.has(day)) {
      report.emptyPosts.push({ day, file: fname })
      toDelete.push(fname)
    }
  }

  // ---- 5) 封面缺失
  const images = fs.existsSync(imagesDir) ? new Set(fs.readdirSync(imagesDir)) : new Set()
  for (const fname of postFiles) {
    const text = postTexts.get(fname)
    const m = text.match(/cover_(\d{8})\.jpg/)
    if (!m) continue
    const cover = `cover_${m[1]}.jpg`
    if (images.has(cover)) continue
    const entry = days.find((d) => d.day === m[1])
    report.missingCovers.push({ day: m[1], cover, recoverable: Boolean(entry) })
    if (fix && entry) {
      const rel = await buildCover(workDir, m[1], entry.playlist.tracks ?? [], { log: () => {} })
      if (rel) report.fixed.push(`${m[1]}: 重新生成 ${cover}`)
    }
  }

  // 删除空文章（放在读取之后，避免 ENOENT）
  if (fix) {
    for (const fname of toDelete) {
      fs.rmSync(path.join(postsDir, fname))
      report.fixed.push(`删除空文章 ${fname}`)
    }
  }

  // ---- 1&2 隔离坏文件 / 空快照
  if (fix) {
    fs.mkdirSync(quarantineDir, { recursive: true })
    for (const item of [...report.corrupt, ...report.empty]) {
      fs.renameSync(item.file, path.join(quarantineDir, path.basename(item.file)))
      report.fixed.push(`隔离 ${path.basename(item.file)}${item.why ? `（${item.why}）` : ''}`)
    }
  }

  return report
}

/** 打印体检结果 */
export function printReport(report, { fix, log = console.log }) {
  const line = (label, arr, extra = '') =>
    log(`  ${(arr.length ? '✗' : '✓')} ${label.padEnd(26)} ${arr.length}${extra}`)

  log(`\n=== 脏数据体检 ===`)
  line('非 JSON / 无 playlist', report.corrupt)
  line('空歌单快照', report.empty)
  line('tracks ≠ trackIds', report.mismatched)
  line('空文章', report.emptyPosts)
  line('文章缺封面图', report.missingCovers)
  log(`  ${report.dateMismatch ? '!' : '✓'} 文件名与描述日期不符      ${report.dateMismatch}（历史时区问题，不改名）`)

  for (const m of report.mismatched) {
    log(`     · ${m.day}: tracks=${m.tracks} trackIds=${m.trackIds}（悬空 ${m.dangling}）`)
  }
  for (const c of report.missingCovers) {
    log(`     · ${c.day}: ${c.cover}${c.recoverable ? '（可从快照重建）' : '（快照缺失，无法重建）'}`)
  }
  for (const c of report.corrupt) {
    log(`     · ${path.basename(c.file)}: ${c.why}`)
  }

  if (fix) {
    log(`\n  已修复 ${report.fixed.length} 项：`)
    for (const f of report.fixed) log(`     ✓ ${f}`)
  } else if (
    report.corrupt.length ||
    report.empty.length ||
    report.mismatched.length ||
    report.emptyPosts.length ||
    report.missingCovers.length
  ) {
    log('\n  加 --fix 执行修复（坏文件会被移到 .quarantine/，不会删除）')
  }
}
