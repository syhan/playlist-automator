/**
 * 生成 Jekyll 文章 + 封面拼图（取代 generate.sh）。
 */

import fs from 'node:fs'
import path from 'node:path'
import { execFile } from 'node:child_process'
import { parseTheme } from './aggregate.mjs'

const MP3_OUTER = 'https://music.163.com/song/media/outer/url?id='

async function download(url, dest) {
  const res = await fetch(url, {
    headers: {
      'User-Agent':
        'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
      Referer: 'https://music.163.com/',
    },
    signal: AbortSignal.timeout(20000),
  })
  if (!res.ok) throw new Error(`HTTP ${res.status}`)
  const buf = Buffer.from(await res.arrayBuffer())
  if (buf.length < 512) throw new Error(`响应过小 (${buf.length}B)`)
  fs.writeFileSync(dest, buf)
}

function run(cmd, args) {
  return new Promise((resolve, reject) => {
    execFile(cmd, args, { maxBuffer: 8 * 1024 * 1024 }, (err, so, se) =>
      err ? reject(new Error(`${cmd} 失败: ${err.message} ${(se || '').slice(0, 200)}`)) : resolve(so),
    )
  })
}

/**
 * 首页马赛克墙用的缩略图：220×220 居中裁剪，约 10KB
 * 生成失败不影响主流程（墙上的瓦片会退化成色块 + 日期）
 */
async function buildThumb(workDir, coverPath, day, { log = console.log } = {}) {
  const dir = path.join(workDir, 'images', 'thumbs')
  fs.mkdirSync(dir, { recursive: true })
  const dest = path.join(dir, `cover_${day}.jpg`)
  try {
    await run('convert', [coverPath, '-resize', '220x220^', '-gravity', 'center', '-extent', '220x220',
      '-strip', '-quality', '70', dest])
    log(`  ✓ 缩略图 ${path.relative(workDir, dest)}`)
  } catch (err) {
    log(`  ! 跳过缩略图（${err.message}）`)
  }
}

/** 下载当日所有专辑封面并拼成一张图，返回相对于 workDir 的路径（失败返回 null） */
export async function buildCover(workDir, day, tracks, { log = console.log } = {}) {
  const tmp = path.join(workDir, '.tmp-covers')
  fs.rmSync(tmp, { recursive: true, force: true })
  fs.mkdirSync(tmp, { recursive: true })

  const urls = [...new Set(tracks.map((t) => t.al?.picUrl).filter(Boolean))]
  const files = []
  for (const [i, url] of urls.entries()) {
    const dest = path.join(tmp, `${String(i).padStart(3, '0')}.jpg`)
    try {
      await download(url, dest)
      files.push(dest)
    } catch (err) {
      log(`  ! 封面下载失败 ${url} → ${err.message}`)
    }
  }
  if (!files.length) {
    fs.rmSync(tmp, { recursive: true, force: true })
    return null
  }

  const imagesDir = path.join(workDir, 'images')
  fs.mkdirSync(imagesDir, { recursive: true })
  const out = path.join(imagesDir, `cover_${day}.jpg`)
  try {
    await run('montage', [...files, out])
    log(`  ✓ 封面拼图 ${path.relative(workDir, out)}（${files.length} 张）`)
    await buildThumb(workDir, out, day, { log })
    return `images/cover_${day}.jpg`
  } catch (err) {
    // imagemagick 不是硬依赖：缺了只影响封面图，不影响文章
    log(`  ! 跳过封面拼图（${err.message}）`)
    return null
  } finally {
    fs.rmSync(tmp, { recursive: true, force: true })
  }
}

/** 生成 _posts/YYYY-MM-DD-fm896-radio.md，返回文件路径 */
export function writePost(workDir, day, playlist, { coverImage, authors, log = console.log } = {}) {
  const meta = parseTheme(playlist.description)
  const title = meta.title || playlist.name || day
  const tags = meta.by || ''
  const dateStr = new Date().toLocaleString('sv-SE', { timeZone: 'Asia/Shanghai' }) // YYYY-MM-DD HH:mm:ss

  const rows = (playlist.tracks ?? [])
    .map((t) => {
      const artists = (t.ar ?? []).map((a) => a.name).join('/')
      return `|${t.name}|${artists}|${MP3_OUTER}${t.id}.mp3|`
    })
    .join('\n')

  const body = [
    '---',
    `layout: post`,
    `title: "${title.replace(/"/g, '\\"')}"`,
    `date: ${dateStr} +0800`,
    `categories: radio`,
    `author: ${authors || ''}`,
    `tags: ${tags}`,
    '---',
    coverImage ? `![]({{site.baseurl}}/${coverImage})\n` : '',
    rows,
    '',
  ].join('\n')

  const postsDir = path.join(workDir, '_posts')
  fs.mkdirSync(postsDir, { recursive: true })
  const file = path.join(postsDir, `${day}-fm896-radio.md`)
  fs.writeFileSync(file, body)
  log(`  ✓ 文章 ${path.relative(workDir, file)}（${(playlist.tracks ?? []).length} 首，主题「${title}」）`)
  return file
}
