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
curl -c cookie.txt "${NETEASE_MUSIC_API}/login?email=${NETEASE_MUSIC_USERNAME}&password=${NETEASE_MUSIC_PASSWORD}" > /dev/null 2>&1

# get current playlist
curl -b cookie.txt "${NETEASE_MUSIC_API}/playlist/detail?id=${NETEASE_MUSIC_PLAYLIST_ID}" -o _data/$TODAY.json

# reflect playlist content, all contents can be recovered if the raw metadata captured
cat _data/$TODAY.json

[ `jq -r '.playlist.tracks | length' _data/$TODAY.json` -eq 0 ] && exit 0 # playlist is empty, normal exit

# delete all tracks extracted from the playlist
tracks=`jq -r '[.playlist.trackIds[].id | tostring] | join(",")' _data/$TODAY.json`
curl -b cookie.txt "${NETEASE_MUSIC_API}/playlist/tracks?op=del&pid=${NETEASE_MUSIC_PLAYLIST_ID}&tracks=$tracks"

# add tracks to the playlist
curl -b cookie.txt "${NETEASE_MUSIC_API}/playlist/tracks?op=add&pid=7072206584&tracks=$tracks"
# put the description of the playlist to the comment
comment=`jq -r '.playlist.description' _data/$TODAY.json`
curl -b cookie.txt "${NETEASE_MUSIC_API}/comment?t=1&type=2&id=7072206584&content=$comment"

rm cookie.txt # then we don't need the cookie anymore, delete for safety purpose

# generate today's article
bash -x ../generate.sh

# statistics to aggregate metrics 
bash -x ../statistics.sh

cd ..
