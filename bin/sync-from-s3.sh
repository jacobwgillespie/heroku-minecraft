declare -a arr=(world server.properties banned-ips.txt banned-players.txt ops.txt white-list.txt)

for i in ${arr[@]}
do
  boto-rsync -a $AWS_KEY -s $AWS_SECRET s3://$S3_BUCKET/$i /app/$i
done