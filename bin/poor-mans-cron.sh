#!/bin/bash
if [ -z "$(pidof poor-mans-cron.sh)"]; then
  while :
  do
    /app/bin/sync-to-s3.sh
    /app/bin/sync-to-s3.sh
    sleep 60
  done
fi
