#!/bin/bash
set -e # in case of any error, stop executing the subsequence command

# get netease cloud music API server running locally
git clone https://github.com/Binaryify/NeteaseCloudMusicApi.git
cd NeteaseCloudMusicApi
npm install
nohup node app.js &
cd ..

TZ='Asia/Shanghai'
TODAY=`date +%Y%m%d`

# fetch previous playlist
git clone --single-branch --branch gh-pages https://github.com/syhan/playlist-automator.git playlists
cd playlists
rm -rf .git # not necessary

# login
curl -c cookie.txt "${NETEASE_MUSIC_API}/login?email=${NETEASE_MUSIC_USERNAME}&password=${NETEASE_MUSIC_PASSWORD}&timestamp=$(date +%s)" > /dev/null 2>&1

# reflect cookie content
cat cookie.txt

# reflect login status
curl -b cookie.txt "${NETEASE_MUSIC_API}/login/status"

# get current playlist
curl -b cookie.txt "${NETEASE_MUSIC_API}/playlist/detail?id=${NETEASE_MUSIC_PLAYLIST_ID}&timestamp=$(date +%s)" -o _data/$TODAY.json

# delete all tracks extracted from the playlist
tracks=`jq -r '[.playlist.trackIds[].id | tostring] | join(",")' _data/$TODAY.json`
#curl -b cookie.txt "${NETEASE_MUSIC_API}/playlist/tracks?op=del&pid=${NETEASE_MUSIC_PLAYLIST_ID}&tracks=$tracks&timestamp=$(date +%s)"
rm cookie.txt # then we don't need the cookie anymore, delete for safety purpose

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

$(jq -r '.playlist.tracks[] | ("|" + .name + "|" + ([.ar[].name] | join("/")) + "|")' _data/$TODAY.json)

EOF

cd ..
