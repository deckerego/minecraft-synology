#!/usr/bin/env bash

if [[ -z $2 ]]; then
  echo "Usage: $0 WORLD_NAME [OPERATOR_USERNAME]"
  exit -1
fi

docker run -e AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY"  -p 25565:25565 ghcr.io/deckerego/minecraft-ecs/minecraft-server:latest $@
