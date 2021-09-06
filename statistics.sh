#!/bin/bash
set -e

# contributor statistics
find ./_data -name "*.json" | xargs jq -r '.playlist.trackIds[].uid' | sort -n | uniq -c | sort -r > contributor_ids
# map user id to nickname
cat contributor_ids | tr -s " " | cut -d " " -f3 | xargs -I {} curl -s "${NETEASE_MUSIC_API}/user/detail?uid={}" | jq -r '.profile | ((.userId | tostring) + " " + .nickname)' > contributor_names
# join user id to get a statistics
join -1 2 contributor_ids contributor_names | sort > contributors

# artist aggregate
find ./_data -name "*.json" | xargs jq -r '.playlist.tracks[].ar[] | .name' | sort | uniq -c | sort -r > artists

# album aggregate
find ./_data -name "*.json" | xargs jq -r '.playlist.tracks[].al.name' | sort | uniq -c | sort -r > albums

# contributor to album
find ./_data -name "*.json" | xargs jq -r '.playlist.trackIds[] | (.id|tostring) + " " + (.uid|tostring)' | sort > track_contributor
find ./_data -name "*.json" | xargs jq -r '.playlist.tracks[] | (.id|tostring) + " " + .al.name' | sort > track_album
join -o 1.2,2.2 track_contributor track_album | sort > contributor_album
join -o 2.2,1.2 track_contributor track_album | sort | uniq -c | sort -r > album_contributor