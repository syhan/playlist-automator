#!/usr/bin/env node
/**
 * playlist-automator — ncm-cli 重写版
 *
 * 与旧 automator.sh 的分工：
 *   读（歌单快照，含点歌人 uid） → 匿名 Web API（开放平台没有这个字段）
 *   写（增删/注释/评论）         → ncm-cli（官方开放平台，token 自动续期）
 *   文章/封面/统计                → 本地文件（imagemagick 只用于封面拼图）
 *
 * 步骤：
 *   snapshot  拉当日快照（匿名 Web API，保留点歌人 uid）
 *   archive   把日更歌单的曲目追加到「全收录」+ 描述存档为评论
 *   clean     清空日更歌单（默认在 archive 之后）
 *   top       重排「精选」为历史重复推荐 Top N
 *   post      生成文章 + 封面拼图
 *   stats     重算统计产物（可选 sqlite）
 *
 * 用法：
 *   node automator.mjs                       # 全流程，只演练不写入
 *   node automator.mjs --apply               # 全流程，真正写入线上
 *   node automator.mjs snapshot post stats   # 只跑指定步骤
 *   node automator.mjs --work ./playlists --apply top
 *
 * 注意：没有 --apply 时，所有**线上写操作**只打印计划；本地文件（_data/_posts/统计）照常生成。
 */

import fs from 'node:fs'
import path from 'node:path'
import { fetchPlaylistDetail, createNicknameResolver } from './lib/webapi.mjs'
import {
  playlistTracks,
  addTracks,
  removeTracks,
  reorderTracks,
  postPlaylistComment,
  listComments,
  searchSongs,
  checkLogin,
} from './lib/ncm.mjs'
import { loadSnapshots, aggregate, topTracks, parseTheme } from './lib/aggregate.mjs'
import { buildCover, writePost } from './lib/post.mjs'
import { writeStats } from './lib/stats.mjs'
import { doctor, printReport } from './lib/doctor.mjs'
import { loadCredentials, loadTokens, saveTokens } from './lib/keystore.mjs'
import { ensureSession } from './lib/auth.mjs'

// ---------------------------------------------------------------- CLI

const STEPS = ['snapshot', 'archive', 'clean', 'top', 'post', 'stats', 'doctor']

function parseArgs(argv) {
  const opts = {
    steps: [],
    work: './playlists',
    config: './config/playlists.json',
    apply: false,
    sqlite: false,
    topN: null,
    day: null,
    cache: './.cache',
    refresh: true,
    refreshMap: false,
    forceRefresh: false,
  }
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i]
    if (a === '--apply') opts.apply = true
    else if (a === '--sqlite') opts.sqlite = true
    else if (a === '--work') opts.work = argv[++i]
    else if (a === '--config') opts.config = argv[++i]
    else if (a === '--top') opts.topN = Number(argv[++i])
    else if (a === '--day') opts.day = argv[++i]
    else if (a === '--cache') opts.cache = argv[++i]
    else if (a === '--no-refresh') opts.refresh = false
    else if (a === '--refresh-map') opts.refreshMap = true
    else if (a === '--force-refresh') opts.forceRefresh = true
    else if (a === 'all') opts.steps.push(...STEPS)
    else if (STEPS.includes(a)) opts.steps.push(a)
    else if (a === '-h' || a === '--help') {
      console.log(fs.readFileSync(new URL(import.meta.url), 'utf8').split('*/')[0].replace(/^\/\*\*?/, ''))
      process.exit(0)
    } else {
      console.error(`未知参数: ${a}`)
      process.exit(2)
    }
  }
  if (!opts.steps.length) opts.steps = [...STEPS]
  return opts
}

const opts = parseArgs(process.argv.slice(2))
const config = JSON.parse(fs.readFileSync(opts.config, 'utf8'))
const tz = config.timezone || 'Asia/Shanghai'
const topN = opts.topN ?? config.topN ?? 20
const P = config.playlists
const workDir = path.resolve(opts.work)
const dataDir = path.join(workDir, '_data')
// 缓存放在仓库根目录，避免被 gh-pages 的 publish_dir 一起发布
const cacheDir = path.resolve(opts.cache)

const dateFmt = new Intl.DateTimeFormat('en-CA', { timeZone: tz })
const day = opts.day ? opts.day.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3') : dateFmt.format(new Date())
const dayCompact = day.replace(/-/g, '')

const log = (...a) => console.log(...a)
const tag = (msg) => `\n=== ${msg} ===`
const rel = (p) => path.relative(process.cwd(), p) || p

// ---------------------------------------------------------------- 工具

const snapshotFile = path.join(dataDir, `${dayCompact}.json`)

function readSnapshot() {
  if (!fs.existsSync(snapshotFile)) {
    throw new Error(`缺少当日快照 ${rel(snapshotFile)}，先跑 snapshot 步骤`)
  }
  return JSON.parse(fs.readFileSync(snapshotFile, 'utf8'))
}

/** 读本地缓存的映射（存在才用，不联网） */
function readSongMapCache() {
  const cacheFile = path.join(cacheDir, 'song-map.json')
  if (!fs.existsSync(cacheFile)) return new Map()
  try {
    const cached = JSON.parse(fs.readFileSync(cacheFile, 'utf8'))
    if (Date.now() - (cached.at ?? 0) > 7 * 24 * 3600 * 1000) return new Map()
    return new Map(Object.entries(cached.map).map(([k, v]) => [Number(k), v]))
  } catch {
    return new Map()
  }
}

/** 数字 ID → 加密 ID 映射（来自"全收录"分页，带 7 天缓存；CI 里默认不用） */
async function buildSongMap({ force = false } = {}) {
  const cacheFile = path.join(cacheDir, 'song-map.json')
  if (!force && fs.existsSync(cacheFile)) {
    const cached = JSON.parse(fs.readFileSync(cacheFile, 'utf8'))
    const age = Date.now() - (cached.at ?? 0)
    if (cached.archive === P.archive.encrypted && age < 7 * 24 * 3600 * 1000) {
      log(`  映射缓存命中：${Object.keys(cached.map).length} 首（${Math.round(age / 3600e3)} 小时前）`)
      return new Map(Object.entries(cached.map).map(([k, v]) => [Number(k), v]))
    }
  }
  log(`  从「${P.archive.name}」建立 数字ID→加密ID 映射（分页 500）…`)
  const tracks = await playlistTracks(P.archive.encrypted, {
    onPage: ({ offset, count, total }) => log(`    offset=${offset} +${count} → 累计 ${total}`),
  })
  const map = new Map(tracks.map((t) => [t.originalId, t.id]))
  fs.mkdirSync(cacheDir, { recursive: true })
  fs.writeFileSync(
    cacheFile,
    JSON.stringify({ at: Date.now(), archive: P.archive.encrypted, map: Object.fromEntries(map) }),
  )
  log(`  映射完成：${map.size} 首`)
  return map
}

/** 用搜索兜底，把 "歌名 歌手" 解析成加密 ID */
async function resolveBySearch(track) {
  const artist = (track.artists ?? []).join(' ')
  const keyword = `${track.name} ${artist}`.trim()
  const records = await searchSongs(keyword, 10)
  const hit =
    records.find((r) => r.name === track.name && r.fullArtists?.some((a) => track.artists?.includes(a.name))) ??
    records.find((r) => r.name === track.name)
  if (!hit) return null
  return hit.id
}

/** 用 gh-pages 里现成的 contributors 文件预热昵称缓存，省掉大量 user/detail 请求（网易限流很紧） */
function seedNicknamesFromContributors() {
  const src = path.join(workDir, 'contributors')
  if (!fs.existsSync(src)) return 0
  const cacheFile = path.join(cacheDir, 'nicknames.json')
  let cache = {}
  try {
    cache = JSON.parse(fs.readFileSync(cacheFile, 'utf8'))
  } catch {
    cache = {}
  }
  let added = 0
  for (const line of fs.readFileSync(src, 'utf8').split('\n')) {
    const m = line.trim().match(/^(\d+)\s+(\d+)\s+(.+)$/)
    if (!m) continue
    const [, uid, , name] = m
    if (name && name !== `用户${uid}` && !cache[uid]?.name) {
      cache[uid] = { name, at: 0, seeded: true }
      added++
    }
  }
  if (added) {
    fs.mkdirSync(cacheDir, { recursive: true })
    fs.writeFileSync(cacheFile, JSON.stringify(cache, null, 2))
  }
  return added
}

// ---------------------------------------------------------------- 步骤

async function stepSnapshot() {
  log(tag(`1. snapshot — ${P.daily.name}（${day}）`))
  const detail = await fetchPlaylistDetail(P.daily.numeric)
  const newCount = (detail.playlist.tracks ?? []).length

  // 重跑保护：clean 之后歌单会变空，不能让空快照覆盖当天已有的内容
  if (fs.existsSync(snapshotFile)) {
    try {
      const prev = JSON.parse(fs.readFileSync(snapshotFile, 'utf8'))
      const prevCount = (prev.playlist?.tracks ?? []).length
      if (prevCount > 0 && newCount === 0) {
        log(`  ! 当日快照已存在（${prevCount} 首），本次拉取为空 —— 保留原快照，不覆盖`)
        return prev.playlist
      }
      if (prevCount > 0 && newCount < prevCount) {
        log(`  ! 注意：曲目从 ${prevCount} 首变为 ${newCount} 首（可能有人手动删了）`)
      }
    } catch {
      log('  ! 旧快照无法解析，将被覆盖')
    }
  }

  fs.mkdirSync(dataDir, { recursive: true })
  fs.writeFileSync(snapshotFile, JSON.stringify(detail))
  const p = detail.playlist
  const meta = parseTheme(p.description)
  log(`  ✓ ${rel(snapshotFile)}`)
  log(`  曲目 ${(p.tracks ?? []).length} 首｜主题「${meta.title}」${meta.by ? `｜点歌人 ${meta.by}` : ''}`)
  if (!(p.tracks ?? []).length) log('  ! 歌单为空：后续写操作将跳过')
  return p
}

async function stepArchive(playlist) {
  log(tag('2. archive — 日更歌单 → 全收录 + 描述存档为评论'))
  if (!(playlist.tracks ?? []).length) {
    log('  跳过：当日歌单为空')
    return
  }
  const current = await playlistTracks(P.daily.encrypted)
  const ids = current.map((t) => t.id)
  if (!ids.length) {
    log('  跳过：日更歌单当前为空')
    return
  }
  log(`  日更歌单现有 ${ids.length} 首：${current.map((t) => t.name).join(' / ')}`)
  const desc = playlist.description ?? ''
  log(`  计划：add ${ids.length} 首 → 「${P.archive.name}」；描述作为评论存档`)

  if (!opts.apply) {
    log('  [dry-run] 未写入。加 --apply 执行。')
    return
  }
  await addTracks(P.archive.encrypted, ids)
  log(`  ✓ 已加入「${P.archive.name}」（${ids.length} 首）`)
  if (desc) {
    // 重跑/补跑时不要重复留言
    const recent = await listComments(P.archive.encrypted, { limit: 20 })
    if (recent.some((c) => (c.content ?? '').trim() === desc.trim())) {
      log(`  = 评论已存在，跳过：${desc}`)
    } else {
      await postPlaylistComment(P.archive.numeric, desc)
      log(`  ✓ 已把描述存档为评论：${desc}`)
    }
  }
}

async function stepClean(playlist) {
  log(tag('3. clean — 清空日更歌单（存档之后才做，避免丢数据）'))
  if (!(playlist.tracks ?? []).length) {
    log('  跳过：当日歌单为空')
    return
  }
  const ids = (await playlistTracks(P.daily.encrypted)).map((t) => t.id)
  if (!ids.length) {
    log('  跳过：日更歌单已经空了')
    return
  }
  log(`  计划：从「${P.daily.name}」移除 ${ids.length} 首`)
  if (!opts.apply) {
    log('  [dry-run] 未写入。加 --apply 执行。')
    return
  }
  await removeTracks(P.daily.encrypted, ids)
  log(`  ✓ 已移除 ${ids.length} 首`)
}

async function stepTop() {
  log(tag(`4. top — 重排「${P.top.name}」为历史重复推荐 Top${topN}`))
  const { days, skipped } = loadSnapshots(dataDir)
  if (skipped.length) log(`  ! 跳过 ${skipped.length} 个坏快照：${skipped.map((s) => s.day).join(', ')}`)
  const agg = aggregate(days)
  const top = topTracks(agg, topN)
  log(`  历史 ${days.length} 天 / ${agg.tracks.size} 首唯一曲目 → Top${top.length}`)
  top.forEach((t, i) => log(`    ${String(i + 1).padStart(2)}. ${String(t.count).padStart(3)}× ${t.name} — ${t.artists.join('/')}`))

  // 加密 ID 来源优先级：当前精选（一次小请求） → 本地缓存的「全收录」映射 → 搜索兜底
  // 不在 CI 里拉「全收录」全量（4319 首 / 9 页 / 每页 ~1MB，跨洋很容易超时）
  const currentTracks = await playlistTracks(P.top.encrypted)
  const map = new Map(currentTracks.map((t) => [t.originalId, t.id]))
  if (opts.refreshMap) {
    for (const [k, v] of await buildSongMap({ force: true })) map.set(k, v)
  } else {
    for (const [k, v] of readSongMapCache()) map.set(k, v)
  }

  const wanted = []
  const wantedByEnc = new Map()
  const missing = []
  for (const t of top) {
    const enc = map.get(t.id) ?? (await resolveBySearch(t))
    if (enc) {
      wanted.push(enc)
      wantedByEnc.set(enc, t)
    } else missing.push(t)
  }
  if (missing.length) {
    log(`  ! ${missing.length} 首无法解析加密 ID，将被跳过：${missing.map((m) => m.name).join(', ')}`)
  }

  const current = currentTracks.map((t) => t.id)
  const wantedSet = new Set(wanted)
  const currentSet = new Set(current)
  const toAdd = wanted.filter((id) => !currentSet.has(id))
  const toRemove = current.filter((id) => !wantedSet.has(id))

  log(`  当前 ${current.length} 首｜目标 ${wanted.length} 首`)
  const setEqual =
    toAdd.length === 0 && toRemove.length === 0 && current.length === wanted.length
  if (setEqual) {
    // 集合已一致，但顺序可能被 NetEase 插到最前面——顺序也算产物，对齐一下
    const sameOrder = current.every((id, i) => id === wanted[i])
    if (sameOrder) {
      log('  集合与顺序都一致，无需改动')
      return
    }
    log('  集合一致，但顺序不同 → 只做重排')
    if (!opts.apply) {
      log('  [dry-run] 未写入。加 --apply 执行。')
      return
    }
    await reorderTracks(P.top.encrypted, wanted)
    log(`  ✓ 已按 Top${wanted.length} 重排`)
    return
  }
  log(`  新增 ${toAdd.length} 首，移除 ${toRemove.length} 首`)
  for (const id of toRemove) {
    const t = currentTracks.find((x) => x.id === id)
    log(`    - ${t?.name ?? id} — ${(t?.artists ?? []).map((a) => a.name).join('/')}`)
  }
  for (const id of toAdd) {
    const t = wantedByEnc.get(id)
    log(`    + ${t ? `${t.count}× ${t.name} — ${t.artists.join('/')}` : id}`)
  }
  if (!opts.apply) {
    log('  [dry-run] 未写入。加 --apply 执行。')
    return
  }
  // 先加后删：任何时刻歌单都不会变空
  if (toAdd.length) {
    await addTracks(P.top.encrypted, toAdd)
    log(`  ✓ 已添加 ${toAdd.length} 首`)
  }
  if (toRemove.length) {
    await removeTracks(P.top.encrypted, toRemove)
    log(`  ✓ 已移除 ${toRemove.length} 首`)
  }
  // 校验集合，再把顺序对齐（NetEase 会把新加的插到最前面）
  const after = await playlistTracks(P.top.encrypted)
  const afterIds = after.map((t) => t.id)
  const afterSet = new Set(afterIds)
  if (afterIds.length !== wanted.length || wanted.some((id) => !afterSet.has(id))) {
    throw new Error(
      `重排后集合与目标不符（实际 ${afterIds.length} 首 / 目标 ${wanted.length} 首），跳过重排以免顺序错乱`,
    )
  }
  await reorderTracks(P.top.encrypted, wanted)
  log(`  ✓ 已按 Top${wanted.length} 重排`)
}

async function stepPost(playlist) {
  log(tag('5. post — 生成文章 + 封面拼图'))
  if (!(playlist.tracks ?? []).length) {
    log('  跳过：当日歌单为空')
    return
  }
  const nicknames = createNicknameResolver(cacheDir)
  const uids = [...new Set((playlist.trackIds ?? []).map((t) => t.uid).filter((u) => u != null))]
  const authors = []
  for (const uid of uids) authors.push(await nicknames.resolve(uid))
  const stat = nicknames.flush()
  log(`  点歌人 ${uids.length} 位（缓存命中 ${stat.hits}，新查 ${stat.fetched}，失败 ${stat.failed}）`)

  const cover = await buildCover(workDir, dayCompact, playlist.tracks ?? [], { log })
  writePost(workDir, day, playlist, { coverImage: cover, authors: authors.join('/'), log })
}

async function stepStats() {
  log(tag('6. stats — 聚合统计'))
  const { days, skipped } = loadSnapshots(dataDir)
  log(`  快照 ${days.length} 天${skipped.length ? `（跳过 ${skipped.length} 个坏文件）` : ''}`)
  const agg = aggregate(days)
  const seeded = seedNicknamesFromContributors()
  if (seeded) log(`  从旧 contributors 预热 ${seeded} 个昵称`)
  const nicknames = createNicknameResolver(cacheDir)
  await writeStats(workDir, days, agg, { nicknames, sqlite: opts.sqlite, log })
  const stat = nicknames.flush()
  log(`  昵称：缓存命中 ${stat.hits}，新查 ${stat.fetched}，未解析 ${stat.failed}`)
  if (stat.failures.length) log(`    例：${stat.failures.join(' | ')}`)
}

async function stepDoctor() {
  const report = await doctor({ workDir, fix: opts.apply, log })
  printReport(report, { fix: opts.apply, log })
  if (opts.apply && report.fixed.length) log('\n  提示：脏数据修复后建议重跑 `stats` 让统计产物同步更新。')
}

// ---------------------------------------------------------------- main

async function main() {
  log(`playlist-automator（ncm-cli 版）｜${opts.apply ? 'APPLY（会写入线上）' : 'DRY-RUN（只读）'}`)
  log(`work=${rel(workDir)}｜day=${day}｜topN=${topN}`)

  // ncm-cli 0.1.7 的自动续期有 bug（见 lib/auth.mjs 注释），这里自己续
  if (opts.refresh && opts.steps.some((s) => ['archive', 'clean', 'top'].includes(s))) {
    try {
      const credentials = loadCredentials()
      const { tokens } = loadTokens()
      const session = await ensureSession({
        credentials,
        tokens,
        log,
        // --force-refresh：无视本地过期时间，强制走一次 refreshToken
        marginMs: opts.forceRefresh ? Number.MAX_SAFE_INTEGER : undefined,
      })
      if (session.refreshed) {
        saveTokens(undefined, session.tokens)
        log(`  ✓ 已续期，有效期至 ${new Date(session.expiresAt).toLocaleString('sv-SE', { timeZone: tz })}`)
      } else {
        log(`登录态：有效至 ${new Date(session.expiresAt).toLocaleString('sv-SE', { timeZone: tz })}`)
      }
      const chk = await checkLogin()
      log(`  ncm-cli 确认：${chk.message ?? 'ok'}`)
    } catch (err) {
      console.error(`\n登录态不可用：${err.message}\n先执行 ncm-cli login（扫码一次）`)
      process.exit(1)
    }
  }

  let playlist = null
  const needSnapshot = opts.steps.some((s) => ['snapshot', 'archive', 'clean', 'post'].includes(s))
  if (opts.steps.includes('snapshot')) playlist = await stepSnapshot()
  else if (needSnapshot) playlist = readSnapshot().playlist

  if (opts.steps.includes('archive')) await stepArchive(playlist)
  if (opts.steps.includes('clean')) await stepClean(playlist)
  if (opts.steps.includes('top')) await stepTop()
  if (opts.steps.includes('post')) await stepPost(playlist)
  if (opts.steps.includes('stats')) await stepStats()
  if (opts.steps.includes('doctor')) await stepDoctor()

  log('\n完成。' + (opts.apply ? '' : '（dry-run：线上未做任何改动）'))
}

main().catch((err) => {
  console.error(`\n✗ 失败：${err.message}`)
  process.exit(1)
})
