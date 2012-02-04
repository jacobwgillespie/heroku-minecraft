#!/bin/bash
. /app/bin/sync-from-s3.sh
echo "`cat /app/server.properties1`\nserver-port=$PORT\n`cat /app/server.properties2`" > /app/server.properties
cd /app
chmod +x /app/bin/poor-mans-cron.sh
/app/bin/poor-mans-cron.sh &
echo $! > cron.pid
java -Xmx512M -Xms512M -jar /app/bin/minecraft_server.jar nogui
kill `cat cron.pid`
. /app/bin/sync-to-s3.sh
