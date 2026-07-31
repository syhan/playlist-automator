#!/usr/bin/env python3
"""生成歌单主题词云图，月份距离当前越近权重越高。"""

import json
import os
import re
from datetime import datetime
from pathlib import Path
from collections import defaultdict
from wordcloud import WordCloud
import matplotlib.pyplot as plt

PROJECT_DIR = Path(__file__).parent
DATA_DIR = PROJECT_DIR / "_data"
OUTPUT_PNG = PROJECT_DIR / "wordcloud_themes.png"
FONT_PATH = "/Library/Fonts/Arial Unicode.ttf"

NOW = datetime(2026, 7, 31)


def months_diff(date_str):
    """计算文件日期距今的月份差。"""
    try:
        dt = datetime.strptime(date_str, "%Y%m%d")
        return (NOW.year - dt.year) * 12 + (NOW.month - dt.month)
    except ValueError:
        return None


def extract_theme(description):
    """从 description 提取主题名：去掉日期、'主题：'/'主题:'、'#'后内容。"""
    if not description:
        return None
    # 去掉开头日期 (各种格式: 2021/07/30, 2021-07-30, 20210730 等)
    text = re.sub(r"^\d{4}[/\-]?\d{2}[/\-]?\d{2}\s*", "", description.strip())
    # 去掉 "主题：" 或 "主题:" 或 "主题: "
    text = re.sub(r"^主题[：:]\s*", "", text)
    # 去掉 # 及其后面的内容
    text = re.sub(r"#.*$", "", text)
    text = text.strip()
    return text if text else None


def main():
    # 收集主题：{theme: set(date_str)} 用于去重（同一主题同一天只算一次）
    theme_dates = defaultdict(set)

    for fname in sorted(os.listdir(DATA_DIR)):
        if not fname.endswith(".json"):
            continue
        date_str = fname.replace(".json", "")
        fpath = DATA_DIR / fname
        try:
            with open(fpath, encoding="utf-8") as f:
                d = json.load(f)
            desc = d.get("playlist", {}).get("description", "")
            theme = extract_theme(desc)
            if theme:
                theme_dates[theme].add(date_str)
        except (json.JSONDecodeError, KeyError):
            pass

    # 计算权重：月份越近权重越高
    # 权重 = 1 / (months_diff + 1)，同一主题多天出现则累加
    max_months = 0
    for theme, dates in theme_dates.items():
        for d in dates:
            md = months_diff(d)
            if md is not None and md > max_months:
                max_months = md

    freq = {}
    for theme, dates in theme_dates.items():
        weight = 0.0
        for d in dates:
            md = months_diff(d)
            if md is not None:
                # 线性权重：最近的月份权重最高
                weight += (max_months - md + 1)
        freq[theme] = weight

    print(f"共 {len(freq)} 个不同主题")
    # 展示 Top 20
    sorted_themes = sorted(freq.items(), key=lambda x: -x[1])
    print(f"\nTop 20 主题（加权）:")
    for theme, w in sorted_themes[:20]:
        print(f"  {w:6.0f}  {theme}")

    # 颜色函数：全彩明快，每个词条不同色
    _color_index = [0]

    def color_func(word, font_size, position, orientation, random_state=None, **kwargs):
        hue = (hash(word) * 137 + _color_index[0] * 53) % 360
        _color_index[0] += 1
        return f"hsl({hue}, 60%, 55%)"

    # 生成词云
    wc = WordCloud(
        font_path=FONT_PATH,
        width=1920,
        height=1080,
        background_color="#faf8f5",
        max_words=300,
        max_font_size=160,
        min_font_size=10,
        color_func=color_func,
        collocations=False,
    )
    wc.generate_from_frequencies(freq)

    plt.figure(figsize=(19.2, 10.8), dpi=100)
    plt.imshow(wc, interpolation="bilinear")
    plt.axis("off")
    plt.tight_layout(pad=0)
    plt.savefig(OUTPUT_PNG, dpi=150, bbox_inches="tight")
    plt.close()

    print(f"\n✅ 主题词云已保存: {OUTPUT_PNG}")


if __name__ == "__main__":
    main()
