#!/bin/bash

function clean_shutdown {
  kill $cron_pid
  . /app/bin/sync-from-s3.sh
}
trap clean_shutdown SIGTERM

# sync initial files
. /app/bin/sync-from-s3.sh

# setup background syncing
nice /app/bin/poor-mans-cron.sh &
cron_pid=$!

# create server config
# echo "server-port=$PORT" >> /app/server.properties

# print logs to stdout
touch /app/server.log
nice tail -f /app/server.log &

# run minecraft
cd /app
java -Xmx1024M -Xms1024M -jar /app/vendor/minecraft_server.1.7.4.jar nogui &

node /app/vendor/node-websocket-tunnel/server.js 0.0.0.0:${PORT}