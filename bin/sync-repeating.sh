#!/bin/bash
if [ -z "$(pidof sync-repeating.sh)"]; then
  while :
  do
    nice /app/bin/sync-to-s3.sh
    nice /app/bin/sync-to-s3.sh
    sleep 300
  done
fi
