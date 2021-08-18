#!/bin/bash
set -e

someday=20210817

[ ! -f /tmp/${someday}.json ] && curl -L https://raw.githubusercontent.com/syhan/playlist-automator/gh-pages/_data/${someday}.json -o /tmp/${someday}.json

# login
curl -c cookie.txt "${NETEASE_MUSIC_API}/login?email=${NETEASE_MUSIC_USERNAME}&password=${NETEASE_MUSIC_PASSWORD}" > /dev/null 2>&1

# reflect login status
curl -b cookie.txt "${NETEASE_MUSIC_API}/login/status"

# extract tracks and title
tracks=$(jq -r '[.playlist.trackIds[].id | tostring] | join(",")' /tmp/${someday}.json)
title=$(jq -r '.playlist.description' /tmp/${someday}.json | sed -r 's/[\/ ]//g' | xxd -ps | tr -d '\n' | sed -r 's/(..)/%\1/g')

# create playlist
curl -b cookie.txt "${NETEASE_MUSIC_API}/playlist/create?name=$title&privacy=10&type=NORMAL" > /tmp/playlist_${someday}.json

# extract the playlist id
playlist_id=$(jq -r '.id' /tmp/playlist_${someday}.json)

# add tracks to the playlist
curl -b cookie.txt "${NETEASE_MUSIC_API}/playlist/tracks?op=add&pid=$playlist_id&tracks=$tracks"