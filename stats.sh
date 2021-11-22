#!/bin/bash
set -e

cat <<EOF > schema.sql
CREATE TABLE contributors (
  UID INTEGER PRIMARY KEY,
  name TEXT
);

CREATE TABLE contributions (
    UID INTEGER,
    TRACK_ID INTEGER,
    DAY DATE
);

CREATE TABLE tracks (
    TRACK_ID INTEGER,
    ALBUM_ID INTEGER,
    ARTIST TEXT,
    NAME TEXT
);

CREATE TABLE albums (
    ALBUM_ID INTEGER PRIMARY KEY,
    NAME TEXT
);


CREATE TABLE history (
    DAY DATE,
    THEME TEXT
);

EOF

# contributors
find ./_data -name "*.json" | xargs jq -r '.playlist.trackIds[].uid' | sort -n | uniq | xargs -I {} curl -s "${NETEASE_MUSIC_API}/user/detail?uid={}" | jq -r "\"INSERT INTO contributors VALUES ('\" + (.profile | (.userId | tostring) + \"', '\" + .nickname) + \"');\"" >> schema.sql

# contributions
find ./_data -name "*.json" | xargs jq -r "\"INSERT INTO contributions VALUES ('\" + (.playlist.trackIds[] | (.uid|tostring) + \"', '\" + (.id|tostring) + \"', '\") + (.playlist.description[0:10]) + \"');\"" >> schema.sql

# tracks
find ./_data -name "*.json" | xargs jq -r "\"INSERT INTO tracks VALUES ('\" + (.playlist.tracks[] | (.id|tostring) + \"', '\" + (.al.id|tostring) + \"', '\" + ([.ar[].name|gsub(\"'\";\"''\")] | join(\"/\")) + \"', '\" + (.name|gsub(\"'\";\"''\"))) + \"');\"" | sort | uniq >> schema.sql

# albums
find ./_data -name "*.json" | xargs jq -r "\"INSERT INTO albums VALUES ('\" + (.playlist.tracks[] | (.al.id|tostring) + \"', '\" + (.al.name|gsub(\"'\";\"''\"))) + \"');\"" | sort | uniq >> schema.sql

# history
find ./_data -name "*.json" | xargs jq -r "\"INSERT INTO history VALUES ('\" + (.playlist | .description[0:10] + \"', '\" + .description[11:100]) + \"');\"" | sort | uniq >> schema.sql

sqlite3 < schema.sql

