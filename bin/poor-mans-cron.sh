#!/bin/bash
if [ -z "$(pidof poor-mans-cron.sh)"]; then
  while :
  do
    sh /app/bin/sync-to-s3.sh
    sh /app/bin/sync-to-s3.sh
    sleep 60
  done
fi