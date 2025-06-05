#!/usr/bin/env bash

cd /srv

echo "Starting server"
trap 'echo "Interrupting server"' SIGINT
trap 'echo "Terminating server"' SIGTERM

echo "Memory  : $MEMORY"
echo "World   : $WORLD"

[[ $OPERATOR ]] && echo $OPERATOR > ops.txt
echo "Operators: "
cat ops.txt

java -Xmx"$MEMORY" -Xms"$MEMORY" -jar server.jar --world "$WORLD" --nogui &
wait $!

echo "Shutting down"
