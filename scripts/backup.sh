#!/bin/bash
# backup.sh - Automated Backup Script

TIMESTAMP=$(date '+%Y-%m-%d_%H%M%S')
PROJECT_DIR="$HOME/devops-project"
BACKUP_DIR="$PROJECT_DIR/backups"
BACKUP_FILE="$BACKUP_DIR/full_backup_$TIMESTAMP.tar.gz"
KEEP_BACKUP=5 # Keep only last five backups

mkdir -p $BACKUP_DIR

echo "Creating backup: $BACKUP_FILE"
tar -czf $BACKUP_FILE \
	--exclude='$PROJECT_DIR/backups' \
	--exclude='$PROJECT_DIR/logs' \
	--exclude='$PROJECT_DIR/.git' \
	$PROJECT_DIR/app \
	$PROJECT_DIR/scripts \
	$PROJECT_DIR/config

# Get backup size
SIZE=$(du -sh $BACKUP_FILE | cut -f1)
echo "Backup complete: $BACKUP_FILE ($SIZE)"

# Keep only the last N backups
ls -t $BACKUP_DIR/full_backup_*.tar.gz | tail -n +$((KEEP_BACKUPS+1)) xargs rm -f
echo "Retained last $KEEP_BACKUPS backups."

# List current backups
echo "Current backups:"
ls -lh $BACKUPS_DIR/
