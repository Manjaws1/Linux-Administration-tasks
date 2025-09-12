#!/bin/bash

# Variables
SRC_DIR="/var/www/html"
BACKUP_DIR="/backup"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/html_backup_${TIMESTAMP}.tar.gz"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Create backup with timestamp
echo "Backing up $SRC_DIR to $BACKUP_FILE..."
tar -czf "$BACKUP_FILE" "$SRC_DIR"

# Check if backup was successful
if [ $? -eq 0 ]; then
    echo "Backup completed successfully: $BACKUP_FILE"
else
    echo "Backup failed!"
    exit 1
fi

# List backups
echo "Available backups in $BACKUP_DIR:"
ls -lh $BACKUP_DIR/html_backup_*.tar.gz
