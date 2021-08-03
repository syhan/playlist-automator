#!/bin/bash
set -e

# fetch previous playlist
git checkout gh-pages -- "*.json"
mkdir playlists
mv *.json playlists/

TODAY=`date +%Y%m%d`

curl -c cookie.txt "${NETEASE_MUSIC_API}/login?email=${NETEASE_MUSIC_USERNAME}&password=${NETEASE_MUSIC_PASSWORD}" > /dev/null 2>&1

curl -b cookie.tst "${NETEASE_MUSIC_API}/login/status"

# get current playlist
curl -b cookie.txt "${NETEASE_MUSIC_API}/playlist/detail?id=${NETEASE_MUSIC_PLAYLIST_ID}" -o playlists/$TODAY.json

cat $TODAY.json

tracks=`jq  -r '[.playlist.trackIds[].id | tostring] | join(",")' $TODAY.json`

# curl -b cookie.txt "${NETEASE_MUSIC_API}/playlist/tracks?op=del&pid=${NETEASE_MUSIC_PLAYLIST_ID}&tracks=$tracks"

rm cookie.txt