#!/bin/bash

# Variables
BACKUP_DIR="/backup"
RESTORE_DIR="/var/www/html_test"  # Use a test folder for safety
LATEST_BACKUP=$(ls -t ${BACKUP_DIR}/html_backup_*.tar.gz | head -n 1)

# Create restore directory if it doesn't exist
mkdir -p "$RESTORE_DIR"

# Restore latest backup
echo "Restoring $LATEST_BACKUP to $RESTORE_DIR..."
tar -xzf "$LATEST_BACKUP" -C /   # Extract to root to maintain original path

# Move restored files to test directory
mv /var/www/html "$RESTORE_DIR"

# Check if restore was successful
if [ $? -eq 0 ]; then
    echo "Restore completed successfully. Files are in $RESTORE_DIR"
else
    echo "Restore failed!"
    exit 1
fi
