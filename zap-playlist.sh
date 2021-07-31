#!/bin/bash
set -e
TODAY=`date +%Y%m%d`

curl -c cookie.txt "${NETEASE_MUSIC_API}/login?email=${NETEASE_MUSIC_USERNAME}&password=${NETEASE_MUSIC_PASSWORD}" > /dev/null 2>&1

curl -b cookie.txt "${NETEASE_MUSIC_API}/playlist/detail?id=${NETEASE_MUSIC_PLAYLIST_ID}" -o $TODAY.json

tracks=`cat $TODAY.json | jq  -r '[.playlist.trackIds[].id ] | join(",")'`

curl -b cookie.txt "${NETEASE_MUSIC_API}/playlist/tracks?op=del&pid=${NETEASE_MUSIC_PLAYLIST_ID}&tracks=$tracks"

git add $TODAY.json
git commit -m "playlist $TODAY"
git push --quite "https://${GH_TOKEN}@${GH_REF}" dada:dada

rm cookie.txt