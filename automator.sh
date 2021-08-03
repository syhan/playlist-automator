#!/bin/bash
set -e # in case of any error, stop executing the subsequence command

# get netease cloud music API server running locally
git clone https://github.com/Binaryify/NeteaseCloudMusicApi.git
cd NeteaseCloudMusicApi
npm install
nohup node app.js &
cd ..

TODAY=`date +%Y%m%d`

# fetch previous playlist
git clone --single-branch --branch gh-pages https://github.com/syhan/playlist-automator.git playlists
cd playlists
rm -rf .git # not necessary

# login
curl -c cookie.txt "${NETEASE_MUSIC_API}/login?email=${NETEASE_MUSIC_USERNAME}&password=${NETEASE_MUSIC_PASSWORD}" > /dev/null 2>&1

# reflect login status
curl -b cookie.tst "${NETEASE_MUSIC_API}/login/status"

# get current playlist
curl -b cookie.txt "${NETEASE_MUSIC_API}/playlist/detail?id=${NETEASE_MUSIC_PLAYLIST_ID}" -o meta/$TODAY.json

# for troubleshooting, could eliminate sometime later
# cat meta/$TODAY.json

# delete all tracks extracted from the playlist
tracks=`jq -r '[.playlist.trackIds[].id | tostring] | join(",")' meta/$TODAY.json`
# [ ! -z "$DRY_RUN" ] && echo "skip delete tracks from playlist" || curl -b cookie.txt "${NETEASE_MUSIC_API}/playlist/tracks?op=del&pid=${NETEASE_MUSIC_PLAYLIST_ID}&tracks=$tracks"
rm cookie.txt # then we don't need the cookie anymore, delete for safety purpose

# extract today playlist title and description
jq -r '.playlist | (.name + "\n" + .description)' meta/$TODAY.json > today.txt
# tracks with name and artist 
jq -r '.playlist.tracks[] | (.name + "/" + ([.ar[].name] | join("&")))' meta/$TODAY.json >> today.txt

title=$(jq -r '.playlist.description' meta/$TODAY.json | sed -r 's/.+：(.+)/\1/')
echo -n | tee _posts/$(date +%Y-%m-%d)-fm896-radio.md << EOF
---
layout: post
title: "$title"
date: $(date "+%Y-%m-%d %H:%M:%S")
categories: radio
---
![]($(jq -r '.playlist.coverImgUrl' meta/$TODAY.json))

$(jq -r '.playlist.tracks[] | ("|" + .name + "|" + ([.ar[].name] | join("/")) + "|")' meta/$TODAY.json)

EOF

cd ..
