#!/bin/bash

function shut_down {
  kill `cat /app/cron.pid`
  . /app/bin/sync-from-s3.sh
}

trap shut_down SIGTERM
cd /app

. /app/bin/sync-from-s3.sh
echo "`cat /app/server.properties1`\nserver-port=$PORT\n`cat /app/server.properties2`" > /app/server.properties
chmod +x /app/bin/poor-mans-cron.sh
/app/bin/poor-mans-cron.sh &
echo $! > /app/cron.pid


java -Xmx512M -Xms512M -jar /app/bin/minecraft_server.jar nogui
