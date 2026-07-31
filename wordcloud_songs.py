#!/usr/bin/env python3
"""生成歌曲出现次数词云图，highlight 达达/达达乐队的歌曲。"""

import csv
from pathlib import Path
from wordcloud import WordCloud
import matplotlib.pyplot as plt

PROJECT_DIR = Path(__file__).parent
CSV_FILE = PROJECT_DIR / "song_counts.csv"
OUTPUT_PNG = PROJECT_DIR / "wordcloud_songs.png"
# Arial Unicode 支持中日韩文（含韩文）
FONT_PATH = "/Library/Fonts/Arial Unicode.ttf"

# 达达乐队歌曲固定高权重
DADA_BOOST_WEIGHT = 20  # 适度提升，不至于与其他歌差距过大


def load_data():
    """读取 CSV，返回 {歌名: count} 和达达歌曲集合。"""
    freq = {}
    dada_songs = set()

    with open(CSV_FILE, encoding="utf-8-sig") as f:
        reader = csv.DictReader(f)
        for row in reader:
            name = row["歌名"]
            count = int(row["出现次数"])
            artists = row.get("歌手", "")
            freq[name] = count
            if "达达" in artists or "达达乐队" in artists:
                dada_songs.add(name)

    return freq, dada_songs


def main():
    freq, dada_songs = load_data()
    print(f"读取 {len(freq)} 首歌曲，其中达达相关 {len(dada_songs)} 首")

    # 将达达歌曲权重统一提升
    boosted_freq = {}
    for name, count in freq.items():
        if name in dada_songs:
            boosted_freq[name] = DADA_BOOST_WEIGHT
        else:
            boosted_freq[name] = count

    # 颜色函数：全彩但柔和，每个词条颜色不同，达达歌曲饱和度稍高以区分
    _color_index = [0]

    def color_func(word, font_size, position, orientation, random_state=None, **kwargs):
        # 用 word + position 确保每个词条独立颜色
        hue = (hash(word) * 137 + _color_index[0] * 53) % 360
        _color_index[0] += 1
        if word in dada_songs:
            return f"hsl({hue}, 70%, 50%)"  # 达达：鲜明活泼
        return f"hsl({hue}, 60%, 55%)"  # 其他：明快柔和

    # 生成词云
    wc = WordCloud(
        font_path=FONT_PATH,
        width=1920,
        height=1080,
        background_color="#faf8f5",  # 米白底色
        max_words=500,
        max_font_size=160,
        min_font_size=10,
        color_func=color_func,
        collocations=False,
    )
    wc.generate_from_frequencies(boosted_freq)

    # 保存
    plt.figure(figsize=(19.2, 10.8), dpi=100)
    plt.imshow(wc, interpolation="bilinear")
    plt.axis("off")
    plt.tight_layout(pad=0)
    plt.savefig(OUTPUT_PNG, dpi=150, bbox_inches="tight")
    plt.close()

    print(f"✅ 词云已保存: {OUTPUT_PNG}")
    print(f"   🔵 深青色 = 达达/达达乐队 ({len(dada_songs)} 首，统一权重 {DADA_BOOST_WEIGHT})")
    print(f"   其他 = 莫兰迪色系（低饱和淡雅）")


if __name__ == "__main__":
    main()
