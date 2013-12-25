#!/bin/bash

function clean_shutdown {
  kill $cron_pid
  . bin/sync-from-s3.sh
}
trap clean_shutdown SIGTERM

# sync initial files
. bin/sync-from-s3.sh

# create server config
# echo "server-port=$PORT" >> /app/server.properties

# print logs to stdout
touch server.log
nice tail -f server.log &

# run minecraft
java -Xmx500M -d64 -jar vendor/minecraft_server.1.7.4.jar nogui