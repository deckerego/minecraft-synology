#!/usr/bin/env bash

if [[ -z $2 ]]; then
  echo "Usage: $0 S3_URL WORLD_NAME [OPERATOR_USERNAME]"
  exit -1
fi

S3_URL="$1"
WORLD="$2"
OPERATOR="$3"

cd /srv

echo "Downloading $S3_URL"
aws s3 sync "$S3_URL" .

echo "Starting server"
trap 'echo "Stopping server"' SIGINT
[[ $OPERATOR ]] && echo $OPERATOR > ops.txt
java -jar server.jar --world "$WORLD" --nogui &
wait $!

echo "Uploading world to $S3_URL"
aws s3 sync . "$S3_URL" --exclude "*" --include "$WORLD/*" --include "*.json"

echo "Shutting down"
