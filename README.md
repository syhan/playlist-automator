# FM89.6 刘群音乐电台

每天把网易云歌单 [FM刘群音乐之声](https://music.163.com/playlist?id=6876152675) 整理一遍，
并把当天的主题和曲目发布成静态站点：<https://syhan.github.io/playlist-automator/>

## 三个歌单

| 角色 | 说明 |
|---|---|
| 日更 | 家人每天改描述（`YYYY/MM/DD 主题：xxx#点歌人`）并往里加歌 |
| 全收录 | 日更的曲目每天追加进来，作为总档案；当天描述也作为评论存档 |
| 精选 | 历史重复推荐次数最多的 20 首，按排名排序 |

## 每天做什么

`node automator.mjs --apply` 依次执行：

| 步骤 | 内容 |
|---|---|
| `snapshot` | 拉当日快照到 `playlists/_data/YYYYMMDD.json`（含点歌人 uid、加歌时间）<br>若与上一篇完全相同、或歌单为空 → 视为没有新一期：不写快照、不出页面 |
| `archive` | 日更曲目 → 全收录；描述存档为评论（重跑自动判重） |
| `clean` | 清空日更歌单（**在 archive 之后**，失败也不会丢数据） |
| `top` | 重算 Top20，先加后删，最后按排名 reorder |
| `post` | 生成 `_posts/YYYY-MM-DD-fm896-radio.md` + 封面拼图 `images/cover_YYYYMMDD.jpg` + 首页用的缩略图 `images/thumbs/cover_YYYYMMDD.jpg` |
| `stats` | 重算 `.stats/` 下的统计（歌曲/艺人/专辑/贡献者、`song_counts.csv`、可选 `stats.db`） |
| `doctor` | 脏数据体检（`--apply` 时修复：补全缺失曲目、隔离坏快照、删空文章、重建封面、删掉内容重复的连续天只留最旧的一天） |

不加 `--apply` 就是演练：只打印计划，线上不动，本地文件照常生成。

```bash
node automator.mjs                    # 全流程演练
node automator.mjs --apply            # 全流程写入
node automator.mjs snapshot post      # 只跑指定步骤
node automator.mjs doctor --apply     # 体检并修复
node automator.mjs top --top 30       # 精选改成 Top30
```

## 依赖

- Node ≥ 20
- [`ncm-cli`](https://www.npmjs.com/package/@music163/ncm-cli)（官方 CLI，负责所有写操作）
- ImageMagick（封面拼图；缺了会自动跳过，不影响文章）
- 一份 gh-pages 工作副本：`git clone -b gh-pages <repo> playlists`

## 凭证

`ncm-cli login` 扫码一次，凭证落在：

```
~/.netease_mcp_device.json                  # deviceId（解密用，必须一起迁移）
~/.config/ncm-cli/credentials.enc.json      # appId + privateKey
~/.config/ncm-cli/tokens.enc.json           # accessToken / refreshToken
```

accessToken 只有 24 小时，`lib/auth.mjs` 会用 refreshToken 自行续期
（ncm-cli 自带的续期有 bug，见该文件注释）。

## 定时任务

`.github/workflows/timer.yml`，**工作日**（周一到周五）北京时间 21:00 跑一次，
也就是 UTC 13:00（GitHub 的 cron 只认 UTC、不认节假日，而且会晚几分钟到十几分钟）：

- 凭证来自 environment `job` 的三个 secret：`NCM_DEVICE` / `NCM_CREDENTIALS` / `NCM_TOKENS`（base64 的原始文件）
- 续期后的 `tokens.enc.json` 通过 Actions cache 传给下一次运行
- `workflow_dispatch` 可手动触发，支持 `dry_run`（只演练）和 `force_refresh`（强制续期）

跑完推一条 [Bark](https://github.com/Finb/Bark) 通知到手机：成功发当天摘要（主题、几首、全收录加了几首、
点开直达当天页面），失败发错误和出错的步骤（`level=timeSensitive`，会穿透专注模式）。

两台设备分两种收法，都放在 environment `job` 的 secret 里：

| secret | 什么时候推 |
|-|-|
| `BARK_URL_ALWAYS` | 不管成败都推 —— 这台收全部 |
| `BARK_URL_ON_SUCCESS` | 只在跑成功时推 —— 这台只收好消息 |

一个变量里塞多条网址（逗号或换行分隔）就多推几台，加设备不用改代码。

```bash
gh secret set BARK_URL_ALWAYS     -e job --repo syhan/playlist-automator   # 粘贴 https://api.day.app/<key>
gh secret set BARK_URL_ON_SUCCESS -e job --repo syhan/playlist-automator
gh workflow run timer.yml --repo syhan/playlist-automator -f dry_run=true  # 演练一次，验证通知
```

通知失败不会让跑批变红（只出一条 warning）——已经跑成的流水线不该被一条推送拖下水。
跑批本身的摘要写在 `RUN_SUMMARY`（默认 `/tmp/automator-run.json`），`lib/bark.mjs` 读它拼文案。

## 站点

首页有两种看法，顶栏左上角切换（会记住选择，`#coverflow` 可直接深链到封面流）：

- **墙**（默认）：一天一块方形瓦片，用当日专辑封面拼图的缩略图，铺满整屏，
  3 列到 21 列自适应；顶栏可跳年份、可切三档密度
- **封面流**：像 iPod 那样一叠封面横向翻，左右方向键 / 拖动 / 滚轮 / 底部滑杆 / 随机，
  回车或点中间那张打开当天。从墙上切过去时会自动定位到你正在看的那一天

封面流用原图（380px），墙用 220px 缩略图；样式在 `assets/mosaic.css`，交互在 `assets/coverflow.js`，
数据直接从墙的 DOM 里读，不额外传 JSON。节目页仍是 pages-themes/minimal 的样式。

## 为什么读快照不用 ncm-cli

开放平台的 `playlist tracks` 不返回 `trackIds[].uid`（点歌人），也不返回加歌时间。
所以快照走匿名 Web 接口 `music.163.com/api/v6/playlist/detail`（不需要登录、不会过期），
ncm-cli 只负责写操作（增删曲目、改描述、发评论、reorder）。

## 目录

```
automator.mjs        入口
lib/auth.mjs         accessToken 续期（自己签名，绕过 ncm-cli 的 bug）
lib/keystore.mjs     凭证文件的加解密读写
lib/ncm.mjs          ncm-cli 封装（分页、重试、错误校验）
lib/webapi.mjs       匿名 Web API（快照 / 昵称 / 歌曲详情）
lib/aggregate.mjs    历史聚合、描述解析
lib/post.mjs         文章 + 封面拼图
lib/stats.mjs        统计产物
lib/doctor.mjs       脏数据体检与修复
config/playlists.json  三个歌单的数字 ID + 加密 ID、TopN、时区
playlists/           gh-pages 工作副本（gitignore）
```
