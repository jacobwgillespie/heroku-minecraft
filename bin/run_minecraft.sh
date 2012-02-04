. /app/bin/sync-from-s3.sh
echo "`cat /app/server.properties1`\nserver-port=$PORT\n`cat /app/server.properties2`" > /app/server.properties
cd /app
java -Xmx512M -Xms512M -jar /app/bin/minecraft_server.jar nogui
. /app/bin/sync-to-s3.sh
