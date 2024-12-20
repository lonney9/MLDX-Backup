#!/bin/bash

# MacLoggerDX Logs backup script
#   Gracefully closes MLDX
#   Creates a tgz archive (gzipped tar file)
#   If number of max_backups has been reached, oldest backup is deleted
#   Starts MLDX
#
# Create the backup folder where you want it, e.g. Documents/MLDX_Backup
#   Script is ready to run as-is from with-in the backup folder
#   It will create the backup files in the current working directory
# To run the script from outside the backup folder
#   Set the path for backup_folder
#   Include trailing slash "/path/to/folder/"

# Number of previous backups to keep
max_backups=5

# Define the source folder
source_folder="$HOME/Documents/MLDX_Logs" 

# Define backup_folder if script is located or run outside of backup folder
backup_folder=""

# Define backup file name
backup_base_name="MLDX_Logs_"
backup_extension=".tgz"

# Create a timestamp with current date-time used in backup name (YYMMDD-HHMMSS)
timestamp=$(date +%Y%m%d-%H%M%S)

# Combine the backup base name, timestamp, extention, and display it
backup_name="${backup_folder}${backup_base_name}${timestamp}${backup_extension}"
echo ""
echo "Creating backup $backup_name"
echo ""

# Gracefully close MacLoggerDX
echo "Closing MacLoggerDX.."
osascript -e 'quit app "MacLoggerDX"'
sleep 2

# Create backup with relative paths.
# Exclude .DS_Store, ADIF conf reports, debug files, and QSL card images
tar \
  -cvz \
  --totals \
  --exclude='.DS_Store' \
  --exclude='./adif_confirmations/reports/*.*' \
  --exclude='./debug_log_files/*.*' \
  --exclude='./qsl/*.*' \
  -f "$backup_name" -C "$source_folder" .

# Display compression stats
gzip -l "$backup_name"
echo ""

# List existing backups order them newest first and count them
backup_list=$(ls -1t "${backup_folder}${backup_base_name}"*"${backup_extension}")
backup_count=$(echo "$backup_list" | wc -l)

# Remove older backups if the count exceeds the maximum
if [ "$backup_count" -gt "$max_backups" ]; then
  backups_to_delete=$(echo "$backup_list" | tail -n $((backup_count - max_backups)))
  echo "More than $max_backups backups, deleting oldest $backups_to_delete"
  echo "$backups_to_delete" | xargs rm
else
  echo "No backups to delete"
fi

echo ""

# Open MacLoggerDX
echo "Starting MacLoggerDX.."
echo ""
open -a /Applications/MacLoggerDX.app