/**
 * Bark 推送（iOS 通知）。
 *
 * 提醒网址分两类，都从环境变量收（一个变量多条用逗号或换行分隔）：
 *   BARK_URL_ALWAYS      不管成败都推（BARK_URLS 是它的别名）
 *   BARK_URL_ON_SUCCESS  只在跑成功时推 —— 成功通知不想被失败打扰的走这条
 * 网址形如 https://api.day.app/<key> 或自建 https://bark.example.com/<key>，
 * 末尾带不带斜杠、带不带 ?group= 都行。
 *
 * 发送失败只打警告、退出码仍是 0 —— 通知挂了不该把已经跑成功的流水线标红。
 */

const TIMEOUT_MS = 10_000

/** 解析一个变量里的多条网址 */
const splitUrls = (v) =>
  (v ?? '')
    .split(/[\n,]+/)
    .map((s) => s.trim())
    .filter((s) => /^https?:\/\//.test(s))

export function collectBarkTargets(env = process.env) {
  const always = splitUrls(env.BARK_URL_ALWAYS).concat(splitUrls(env.BARK_URLS))
  const onSuccess = splitUrls(env.BARK_URL_ON_SUCCESS)
  return { always: [...new Set(always)], onSuccess: [...new Set(onSuccess)] }
}

/** 这一次要推给谁 */
export function pickBarkUrls(targets, { ok }) {
  return ok ? [...targets.always, ...targets.onSuccess.filter((u) => !targets.always.includes(u))] : [...targets.always]
}

/** 把标题/正文拼进路径：<key>/<title>/<body>；原有 query 保留，额外参数合并 */
export function buildBarkUrl(base, { title = '', body = '', url, group, level, sound, icon } = {}) {
  const u = new URL(base)
  const seg = [title, body].map((s) => encodeURIComponent(s ?? '')).join('/')
  u.pathname = `${u.pathname.replace(/\/+$/, '')}/${seg}`
  const extra = { url, group, level, sound, icon }
  for (const [k, v] of Object.entries(extra)) if (v != null && v !== '') u.searchParams.set(k, String(v))
  return u.toString()
}

/** 逐条推送；返回 [{ url（脱敏）, ok, message }] */
export async function sendBark(urls, opts = {}, { log = console.log } = {}) {
  const results = []
  for (const base of urls) {
    const masked = base.replace(/(https?:\/\/[^/]+)\/(.{0,6}).*/, '$1/$2…')
    try {
      const res = await fetch(buildBarkUrl(base, opts), { signal: AbortSignal.timeout(TIMEOUT_MS) })
      const text = (await res.text()).slice(0, 200)
      let json = null
      try {
        json = JSON.parse(text)
      } catch {
        /* 非 JSON（比如网关错误页） */
      }
      const ok = res.ok && (json?.code == null ? true : json.code === 200)
      const message = json?.message ?? (ok ? 'ok' : text || `HTTP ${res.status}`)
      results.push({ url: masked, ok, message })
      log(`  ${ok ? '✓' : '✗'} Bark ${masked}：${message}`)
    } catch (err) {
      const message = err?.name === 'TimeoutError' ? `${TIMEOUT_MS / 1000}s 超时` : String(err?.message ?? err)
      results.push({ url: masked, ok: false, message })
      log(`  ✗ Bark ${masked}：${message}`)
    }
  }
  return results
}

/** 从 automator 写的运行摘要拼出通知内容 */
export function composeFromSummary(summary, { site = 'https://syhan.github.io/playlist-automator' } = {}) {
  const day = summary?.day ?? ''
  const mmdd = day.slice(5).replace('-', '.')

  if (summary?.error) {
    return {
      title: `✗ FM89.6 日更失败 · ${mmdd || '未知日期'}`,
      body: `${summary.error}\n${summary.failedStep ? `步骤：${summary.failedStep}` : ''}`.trim(),
      url: `${site}/`,
      group: 'FM89.6',
      level: 'timeSensitive',
      failed: true,
    }
  }

  const lines = []
  if (summary?.duplicate) {
    lines.push(summary.duplicateReason ?? '今天与上一期完全一致，不发布')
  } else {
    const theme = summary?.theme ? `主题「${summary.theme}」` : '无主题'
    const by = summary?.by ? ` · 点歌人 ${summary.by}` : ''
    lines.push(`${theme}${by}`)
    const bits = []
    if (summary?.tracks) bits.push(`${summary.tracks} 首`)
    if (summary?.archived) bits.push(`全收录 +${summary.archived}`)
    if (summary?.top?.size) bits.push(`精选 ${summary.top.size} 首`)
    if (bits.length) lines.push(bits.join(' · '))
  }
  if (!summary?.apply) lines.push('（演练模式，线上未改动）')
  if (summary?.warnings?.length) lines.push(`⚠️ ${summary.warnings.length} 条警告，见 Actions 日志`)

  return {
    title: `${summary?.apply ? '' : '[演练] '}FM89.6 日更 · ${mmdd}`,
    body: lines.filter(Boolean).join('\n'),
    url: summary?.post?.url ?? site + '/',
    group: 'FM89.6',
    failed: false,
  }
}

// ---------------------------------------------------------------- CLI

if (import.meta.main ?? process.argv[1]?.endsWith('bark.mjs')) {
  const fs = await import('node:fs')
  const args = process.argv.slice(2)
  const flag = (name) => {
    const i = args.indexOf(`--${name}`)
    return i >= 0 ? (args[i + 1] && !args[i + 1].startsWith('--') ? args[i + 1] : true) : null
  }

  const targets = collectBarkTargets()
  const total = targets.always.length + targets.onSuccess.length
  if (!total) {
    console.log('没有配置 Bark 提醒网址（BARK_URL_ALWAYS / BARK_URL_ON_SUCCESS），跳过推送')
    process.exit(0)
  }

  let payload
  const summaryFile = flag('summary')
  if (typeof summaryFile === 'string') {
    // 摘要文件可能不存在：凭证/依赖那几步就挂了，automator 根本没机会写
    let summary = null
    if (fs.existsSync(summaryFile)) {
      try {
        summary = JSON.parse(fs.readFileSync(summaryFile, 'utf8'))
      } catch {
        summary = null
      }
    }
    const status = process.env.RUN_STATUS
    if (!summary?.error && status === 'failure') {
      summary = { ...(summary ?? {}), error: '跑批失败，浏览器看 Actions 日志' }
    }
    payload = composeFromSummary(summary ?? {})
  } else if (flag('test')) {
    payload = { title: 'Bark 测试', body: '提醒网址配好了，收到即正常。', group: 'FM89.6' }
  } else {
    payload = { title: flag('title') || 'playlist-automator', body: flag('body') || '通知测试' }
  }

  // 成败判定：automator 写了 error，或者前面某一步挂了（job.status=failure）
  const ok = !payload.failed && process.env.RUN_STATUS !== 'failure'
  const urls = flag('test') ? [...new Set([...targets.always, ...targets.onSuccess])] : pickBarkUrls(targets, { ok })
  console.log(
    `${ok ? '成功' : '失败'} → 推 ${urls.length}/${total} 条` +
      (ok ? '' : `（BARK_URL_ON_SUCCESS 的 ${targets.onSuccess.length} 条只在成功时推）`),
  )
  if (!urls.length) {
    console.log('这一类没有配置提醒网址，跳过推送')
    process.exit(0)
  }

  const results = await sendBark(urls, payload)
  const delivered = results.filter((r) => r.ok).length
  console.log(`送达 ${delivered}/${results.length}`)
  // 只有手动 --test 才用退出码报错；跑批里通知失败只出警告，
  // 免得已经跑成的流水线因为一条通知变红。
  if (flag('test')) process.exit(delivered > 0 ? 0 : 1)
  if (!delivered) console.log(`::warning::${results.length} 条 Bark 提醒都没送达，检查 BARK_URL_* 是否过期`)
  process.exit(0)
}
