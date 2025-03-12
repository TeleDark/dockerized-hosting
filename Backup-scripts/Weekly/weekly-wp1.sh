#!/bin/ash
target_dir="/backup/wp_instance1"
weekly_dir="/Backup/Weekly/wp_instance1"
daily_dir="/Backup/Daily/wp_instance1"
if ! cd "$weekly_dir"; then
  mkdir -p "$weekly_dir" && cd "$weekly_dir" || { echo "Failed to create and access $weekly_dir"; exit 1; }
fi
weekly_snapshot="full-$(date +%Y-%m-%d).ss"
weekly_backup="full-$(date +%Y-%m-%d).tar"
tar -cf "$weekly_backup" -g "$weekly_snapshot" "$target_dir" || { echo "Failed to create full backup archive $weekly_backup"; exit 1; }
archive_file="$weekly_dir/$(date -d "-7 days" +%Y-%m-%d)-to-$(date +%Y-%m-%d).tar.gz"
find "$daily_dir" -type f | tar -czf "$archive_file" -T - || { echo "Failed to archive daily backups"; exit 1; }
find "$weekly_dir" -type f -mtime +30 -delete || { echo "Failed to delete old files"; exit 1; }