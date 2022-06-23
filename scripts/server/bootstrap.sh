#!/usr/bin/env bash

S3_URL="$1"
WORLD="$2"
OPERATOR="$3"

cd /srv

echo "Downloading $S3_URL"
aws s3 sync "$S3_URL" .

echo "Starting server"
echo $OPERATOR > ops.txt

trap 'echo "Stopping server"' SIGINT
java -jar server.jar --world "$WORLD" --nogui &
wait $!

echo "Uploading world to $S3_URL"
aws s3 sync . "$S3_URL" --exclude "*" --include "$WORLD/*" --include "*.json"

echo "Shutting down"
