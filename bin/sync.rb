class Sync
  WORLD = ["world"]
  ADMIN = [
    "server.properties",
    "banned-ips.txt",
    "banned-players.txt",
    "ops.txt",
    "white-list.txt"
  ]

  def self.initial_sync
    puts "[sync] Performing initial S3 sync..."
    WORLD.each do |f|
      pull_from_s3 f
    end
    ADMIN.each do |f|
      pull_from_s3 f
    end
    puts "[sync] Sync complete"
  end

  def self.normal_sync
    puts "[sync] Performing S3 sync..."
    WORLD.each do |f|
      push_to_s3 f
    end
    ADMIN.each do |f|
      pull_from_s3 f
    end
    puts "[sync] Sync complete"
  end

  def self.push_to_s3(filename)
    `boto-rsync -a $AWS_KEY -s $AWS_SECRET \
      /app/#{filename} s3://$S3_BUCKET/#{filename}`
  end

  def self.pull_from_s3(filename)
    `boto-rsync -a $AWS_KEY -s $AWS_SECRET \
      s3://$S3_BUCKET/#{filename} /app/#{filename}`
  end
end

# Run
if ARGV[0] == "init"
  Sync.initial_sync
elsif ARGV[0] == "repeating"
  sleeptime = ARGV[1] ? ARGV[1].to_i : 250
  puts "Scheduling sync every #{sleeptime} seconds"
  loop do
    Sync.normal_sync
    sleep sleeptime
  end
else
  Sync.normal_sync
end
