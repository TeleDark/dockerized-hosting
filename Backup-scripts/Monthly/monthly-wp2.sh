#!/bin/ash
target_dir="/backup/wp_instance2"
weekly_dir="/Backup/Weekly/wp_instance2"
monthly_dir="/Backup/Monthly/wp_instance2"
if ! cd "$monthly_dir"; then
  mkdir -p "$monthly_dir" && cd "$monthly_dir" || { echo "Failed to create and access $monthly_dir"; exit 1; }
fi
archive_file="$monthly_dir/$(date -d "-30 days" +%Y-%m-%d)-to-$(date +%Y-%m-%d).tar.gz"
find "$weekly_dir" -type f | tar -czf "$archive_file" -T - || { echo "Failed to archive weekly backups"; exit 1; }
find "$monthly_dir" -type f -mtime +365 -delete || { echo "Failed to delete old files"; exit 1; }