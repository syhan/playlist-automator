#!/usr/bin/env python3
"""统计 _data 目录下所有歌单 JSON 中歌曲出现次数及歌手，导出为 CSV。"""

import json
import os
import csv
from collections import Counter
from pathlib import Path

DATA_DIR = Path(__file__).parent / "_data"
OUTPUT_CSV = Path(__file__).parent / "song_counts.csv"


def main():
    # key: song_name, value: {"count": int, "artists": set}
    song_data = {}
    file_count = 0

    for fname in sorted(os.listdir(DATA_DIR)):
        if not fname.endswith(".json"):
            continue
        fpath = DATA_DIR / fname
        try:
            with open(fpath, encoding="utf-8") as f:
                d = json.load(f)
            tracks = d.get("playlist", {}).get("tracks", [])
            for t in tracks:
                name = t.get("name", "").strip()
                if not name:
                    continue
                # 提取歌手列表
                artists = [a.get("name", "") for a in t.get("ar", [])]
                artists_str = " / ".join(a for a in artists if a)

                if name not in song_data:
                    song_data[name] = {"count": 0, "artists": set()}
                song_data[name]["count"] += 1
                if artists_str:
                    song_data[name]["artists"].add(artists_str)
            file_count += 1
        except (json.JSONDecodeError, KeyError) as e:
            print(f"⚠️  跳过 {fname}: {e}")

    # 按次数降序、同次数按歌名排序
    sorted_songs = sorted(song_data.items(), key=lambda x: (-x[1]["count"], x[0]))

    with open(OUTPUT_CSV, "w", newline="", encoding="utf-8-sig") as f:
        writer = csv.writer(f)
        writer.writerow(["歌名", "歌手", "出现次数"])
        for name, info in sorted_songs:
            # 多个歌手组合用 "; " 分隔（同一首歌可能在不同天有不同艺人标记）
            artists_combined = "; ".join(sorted(info["artists"]))
            writer.writerow([name, artists_combined, info["count"]])

    print(f"✅ 统计完成：{file_count} 天数据，{len(song_data)} 首不同歌曲")
    print(f"📄 已导出: {OUTPUT_CSV}")
    print(f"\n{'='*40}")
    print(f"Top 20:")
    print(f"{'='*40}")
    for name, info in sorted_songs[:20]:
        artists = "; ".join(sorted(info["artists"]))
        print(f"  {info['count']:4d}  {name}  [{artists}]")


if __name__ == "__main__":
    main()
