#!/bin/bash
set -e # in case of any error, stop executing the subsequence command

TODAY=`date +%Y%m%d`

mkdir playlists

# fetch previous playlist
git clone --single-branch --branch gh-pages https://github.com/syhan/playlist-automator.git tmp
mv tmp/*.* playlists/
rm -rf tmp/

cd playlists

# login
curl -c cookie.txt "${NETEASE_MUSIC_API}/login?email=${NETEASE_MUSIC_USERNAME}&password=${NETEASE_MUSIC_PASSWORD}" > /dev/null 2>&1

# reflect login status
curl -b cookie.tst "${NETEASE_MUSIC_API}/login/status"

# get current playlist
curl -b cookie.txt "${NETEASE_MUSIC_API}/playlist/detail?id=${NETEASE_MUSIC_PLAYLIST_ID}" -o $TODAY.json

# for troubleshooting, could eliminate sometime later
cat $TODAY.json

# delete all tracks extracted from the playlist
tracks=`jq -r '[.playlist.trackIds[].id | tostring] | join(",")' $TODAY.json`
# [ ! -z "$DRY_RUN" ] && echo "skip delete tracks from playlist" || curl -b cookie.txt "${NETEASE_MUSIC_API}/playlist/tracks?op=del&pid=${NETEASE_MUSIC_PLAYLIST_ID}&tracks=$tracks"
rm cookie.txt # then we don't need the cookie anymore, delete for safety purpose

# extract today playlist title and description
jq -r '.playlist | (.name + "\n" + .description)' $TODAY.json > today.txt

# tracks with name and artist 
jq -r '.playlist.tracks[] | (.name + "/" + ([.ar[].name] | join("&")))' $TODAY.json >> today.txt

cd ..
