#!/bin/bash 
set -e

TZ='Asia/Shanghai'
TODAY=`date +%Y%m%d`

# extract today playlist title and description
jq -r '.playlist | (.name + "\n" + .description)' _data/$TODAY.json > today.txt
# tracks with name and artist 
jq -r '.playlist.tracks[] | (.name + "/" + ([.ar[].name] | join("&")))' _data/$TODAY.json >> today.txt

# extract author of the playlist
jq -r '.playlist.trackIds[].uid' _data/$TODAY.json | sort | uniq | xargs -I '{}' curl -s "${NETEASE_MUSIC_API}/user/detail?uid={}" | jq -r '.profile.nickname' > authors.txt
authors=`paste -sd '/' authors.txt`
rm authors.txt

mkdir covers
# extract cover image urls
jq -r '.playlist.tracks[].al.picUrl' _data/$TODAY.json > covers/cover_urls.txt
cd covers
wget --quiet -nc -i cover_urls.txt
montage '*.jpg' ../images/cover_$TODAY.jpg
cd ..
rm -rf covers

# extract title
title=$(jq -r '.playlist.description' _data/$TODAY.json | sed -r 's/.+：(.+)/\1/') # CAUSION! the colon was a Chinese colon:(
# generate a jekyll post page
echo -n | tee _posts/$(date +%Y-%m-%d)-fm896-radio.md << EOF
---
layout: post
title: "$title"
date: $(date "+%Y-%m-%d %H:%M:%S") +0800
categories: radio
author: $authors
---
![]({{site.baseurl}}/images/cover_$TODAY.jpg)

$(jq -r '.playlist.tracks[] | ("|" + .name + "|" + ([.ar[].name] | join("/")) + "|https://music.163.com/song/media/outer/url?id=" + (.id|tostring) + ".mp3|")' _data/$TODAY.json)

EOF