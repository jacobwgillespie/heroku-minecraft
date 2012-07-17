#!/bin/bash
if [ -z "$(pidof poor-mans-cron.sh)"]; then
  while :
  do
    nice /app/bin/sync-to-s3.sh
    nice /app/bin/sync-to-s3.sh
    sleep 60
  done
fi
