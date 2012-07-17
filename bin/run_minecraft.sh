#!/bin/bash

function shut_down() {
  kill `cat /app/cron.pid`
  . /app/bin/sync-from-s3.sh
}
trap shut_down SIGTERM

# sync initial files
. /app/bin/sync-from-s3.sh

# setup background syncing
/app/bin/poor-mans-cron.sh &
echo $! > /app/cron.pid

# create server config
cp /app/server.properties1 /app/server.properties
echo "server-port=$PORT" >> /app/server.properties
cat /app/server.properties2 >> /app/server.properties

# run minecraft
cd /app
java -Xmx512M -Xms512M -jar /app/bin/minecraft_server.jar nogui
