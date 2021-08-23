#!/bin/bash
set -e

# contributor statistics
find ./_data -name "*.json" | xargs jq -r '.playlist.trackIds[].uid' | sort -n | uniq -c | sort -r > contributor_ids
cat contributor_ids | tr -s " " | cut -d " " -f3 | xargs -I {} curl -s "${NETEASE_MUSIC_API}/user/detail?uid={}" | jq -r '.profile | ((.userId | tostring) + " " + .nickname)' > contributor_names

join -1 2 contributor_ids contributor_names > contributors

