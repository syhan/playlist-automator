# A playlist automator

![Travis CI](https://travis-ci.org/syhan/playlist-automator.svg?branch=dada)

Automatic job to clean playlist for <https://music.163.com/playlist?id=6876152675&userid=20226098> every night,
save it and publish to <https://syhan.github.io/playlist-automator/>

---

## ncm-cli 重写版（`rewrite/ncm-cli` 分支）

旧实现依赖第三方 [NeteaseCloudMusicApi](https://github.com/Binaryify/NeteaseCloudMusicApi) 实例 + 手工维护的
`cookie.txt`。**该 cookie 在 2024-11-05 失效，之后写操作全部静默失败（`code:301 / 需要登录`），
只有匿名的读接口还能用**——所以站点一直在更新，但「全收录」和「精选」冻结了一年。

新版把职责拆开：

| 职责 | 实现 | 原因 |
|---|---|---|
| 歌单快照（含点歌人 `uid`） | 匿名 Web API `music.163.com/api/v6/playlist/detail` | 开放平台**不返回** `trackIds[].uid`，无需登录也不会过期 |
| 增删曲目 / 改描述 / 发评论 | `ncm-cli`（官方开放平台） | `appId`+`privateKey` 本地签名，token 24h 自动续期，错误码明确 |
| uid → 昵称 | 匿名 Web API `api/v1/user/detail/<uid>` + 本地缓存 | ncm-cli 只有 `user info`（自己） |
| 文章 / 封面 / 统计 | 本地 Node + imagemagick | 无 CLI 替代 |

### 快速开始

```bash
# 依赖
npm i -g @music163/ncm-cli        # 系统 npm，装到 ~/.local
node -v                           # >= 20

# 一次性的登录（扫码，之后自动续期）
ncm-cli login

# 把 gh-pages 拉下来当工作副本（_data / _posts / images / 统计产物）
git clone --single-branch --branch gh-pages https://github.com/syhan/playlist-automator.git playlists

# 演练（只读，不写线上）
node automator.mjs

# 真正执行
node automator.mjs --apply
```

### 步骤

| 步骤 | 做什么 | 写线上 |
|---|---|---|
| `snapshot` | 拉当日快照 → `playlists/_data/YYYYMMDD.json`（保留 `uid`/`at`） | 否 |
| `archive` | 日更歌单的曲目 → 追加到「全收录」；描述存档为评论 | 是 |
| `clean` | 清空日更歌单（**在 archive 之后**） | 是 |
| `top` | 重排「精选」为历史重复推荐 Top N（先加后删，最后按排名 reorder） | 是 |
| `post` | 生成 `_posts/YYYY-MM-DD-fm896-radio.md` + `images/cover_YYYYMMDD.jpg` | 否 |
| `stats` | 重算 `contributors/tracks/artists/albums/song_counts.csv/...`（`--sqlite` 额外生成 `stats.db`） | 否 |
| `doctor` | 脏数据体检；`--apply` 时修复（补全曲目、隔离坏文件、删空文章、重建封面） | 否 |

不加 `--apply` 时所有线上写操作只打印计划；本地文件照常生成。

```bash
node automator.mjs snapshot post stats      # 只跑只读步骤
node automator.mjs --apply archive          # 只做存档
node automator.mjs --apply top --top 30     # 精选改成 Top30
node automator.mjs --day 2026-11-19 post    # 补某一天的文章
```

### 与旧脚本的行为差异

- **时区**：旧脚本 `TZ='Asia/Shanghai'` 没有 `export`，`date` 子进程拿不到 → 快照文件名用 UTC 日期，
  与描述里的北京日期差一天。新版按配置里的 `timezone` 生成日期。
- **顺序**：先 `add` 到「全收录」再 `clean`，任何一步失败都不会丢数据（旧版先删后加）。
- **失败可见**：所有 `ncm-cli` 调用都校验 `code === 200`，失败直接抛错（旧版 `curl` 无 `-f`、
  `set -e` 被注释，所以绿了一年）。
- **坏快照**：遇到非 JSON（历史上的 Vercel 500/超时）只跳过并告警，不会中断。
  > 顺带发现：旧的 `statistics.sh` 用 `find | xargs jq`，**jq 遇到坏文件会终止该批次后续所有文件**，
  > 所以旧统计其实一直在少算（`tracks` 只收录 4080 首，真实 4747 首；Top1 计 21 次，真实 23 次）。
- **幂等**：重跑不会把当天快照覆盖成空（`clean` 之后歌单为空，新版会保留已有快照）。
- **描述**：不再自动写入「？？？」，描述由人维护；只把当天描述存档为评论。

### 脏数据体检 / 修复

```bash
node automator.mjs doctor            # 只报告
node automator.mjs doctor --apply    # 修复
```

能自动处理的六类问题（都已在 gh-pages 的历史数据上跑过一次）：

| 问题 | 数量 | 处理方式 |
|---|---|---|
| 快照不是 JSON（Vercel 500/超时被存了下来） | 2 | 移到 `_data/.quarantine/` |
| 空歌单快照（旧脚本本该删掉） | 3 | 移到 `_data/.quarantine/` |
| `tracks` 少于 `trackIds`（曲目详情缺失，点歌人 uid 悬空） | 7 | 用 `api/v3/song/detail` 补全，补不到才裁剪 |
| 空文章（坏快照生成的 `title: ""`） | 2 | 删除 |
| 文章引用的封面图缺失 | 1 | 用当天快照重新拼图 |
| 文件名日期与描述日期不符 | 515 | **只报告不改名**（描述日期有人工笔误，如 `20250107` 写成 `2024/01/07`） |

修复后统计口径变化：`tracks` 4080 → **4761** 首、`song_counts.csv` 4239 → **4317** 行。

### 已知 gap（无法用 ncm-cli 完成）

1. `trackIds[].uid`（点歌人）—— 开放平台没有该字段，走匿名 Web API 补。
2. `uid → 昵称` —— 同上，且接口限流严格（405/406「操作频繁」），已做串行 + 退避 + 本地缓存。
3. 数字 ID ↔ 加密 ID —— 开放平台只认加密 ID；映射从「全收录」分页建立（4319 首 / 9 页），
   带 7 天缓存，缺失的用 `search song` 兜底。
4. 封面拼图 —— imagemagick；词云 —— `wordcloud_songs.py` / `wordcloud_themes.py` 仍需 python
   （且字体路径写死成 macOS 的 `/Library/Fonts/Arial Unicode.ttf`，在 Linux/CI 上跑不了）。
   输入数据 `song_counts.csv` 已由 `stats` 生成。
5. `playlist create` 不能设隐私和描述（可后补 `updateDesc`）。

### 旧的脚本

`automator.sh` / `generate.sh` / `statistics.sh` / `stats.sh` / `login.sh` / `recover.sh` 保留作参考，
已被 `automator.mjs` 取代（`.github/workflows/timer.yml` 仍指向旧脚本）。
