#!/usr/bin/env bash

if [[ -z $3 ]]; then
  echo "Usage: $0 WORLD_NAME MEMORY_RESERVATION [OPERATOR_USERNAME]"
  exit -1
fi

WORLD="$2"
MEMORY="$3"
OPERATOR="$4"

cd /srv

echo "Starting server"
trap 'echo "Interrupting server"' SIGINT
trap 'echo "Terminating server"' SIGTERM

[[ $OPERATOR ]] && echo $OPERATOR > ops.txt
java -Xmx"$MEMORY" -Xms"$MEMORY" -jar server.jar --world "$WORLD" --nogui &
wait $!

echo "Shutting down"
