#!/usr/bin/env bash

if [[ -z $3 ]]; then
  echo "Usage: $0 S3_URL WORLD_NAME MEMORY_RESERVATION [OPERATOR_USERNAME]"
  exit -1
fi

S3_URL="$1"
WORLD="$2"
MEMORY="$3"
OPERATOR="$4"

cd /srv

echo "Downloading $S3_URL"
aws s3 sync "$S3_URL" .

echo "Starting server"
trap 'echo "Interrupting server"' SIGINT
trap 'echo "Terminating server"' SIGTERM

[[ $OPERATOR ]] && echo $OPERATOR > ops.txt
java -Xmx"$MEMORY" -Xms"$MEMORY" -jar server.jar --world "$WORLD" --nogui &
wait $!

echo "Uploading world to $S3_URL"
aws s3 sync . "$S3_URL" --exclude "*" --include "$WORLD/*" --include "*.json"

echo "Shutting down"
