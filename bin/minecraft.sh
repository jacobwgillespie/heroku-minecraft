#!/bin/bash

function clean_shutdown {
  kill $cron_pid
  . bin/sync-from-s3.sh
}
trap clean_shutdown SIGTERM

# create server config
echo "server-port=25566" > /app/server.properties

# sync initial files
ruby bin/sync.rb init

# print logs to stdout
touch server.log
nice tail -f server.log &

# run minecraft
java -Xmx1024M -Xms1024M -jar vendor/minecraft_server.jar nogui
