#!/bin/sh
if [ ! -d /app/my_new_env ]; then
  . /app/bin/setup_rsync.sh
else
  . /app/my_new_env/bin/activate
fi
boto-rsync -a $AWS_KEY -s $AWS_SECRET /app/world s3://$S3_BUCKET/world
