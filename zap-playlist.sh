#!/bin/bash -e
TODAY=`date +%Y%m%d`

curl -c cookie.txt "${NETEASE_MUSIC_API}/login?email=${NETEASE_MUSIC_USERNAME}&password=${NETEASE_MUSIC_PASSWORD}" > /dev/null 2>&1

curl -b cookie.txt "${NETEASE_MUSIC_API}/playlist/detail?id=${NETEASE_MUSIC_PLAYLIST_ID}" -o $TODAY.json

cat $TODAY.json

tracks=`cat $TODAY.json | jq  -r '[.playlist.trackIds[].id ] | join(",")'`

curl -b cookie.txt "${NETEASE_MUSIC_API}/playlist/tracks?op=del&pid=${NETEASE_MUSIC_PLAYLIST_ID}&tracks=$tracks"

rm cookie.txt