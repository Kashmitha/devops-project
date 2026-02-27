#!/bin/bash
# log_monitor.sh - Log Management Script 

LOG_DIR="$HOME/devops-project/logs" 
MAX_SIZE_MB=10 # Rotate logs larger than 10MB 
KEEP_DAYS=7 # Keep logs for 7 days 

echo "[$(date)] Starting log management..." 

# Count total logs 
TOTAL=$(ls $LOG_DIR/*.log 2>/dev/null | wc -l) 
echo "Found $TOTAL log files" 

# Delete logs older than KEEP_DAYS 
DELETED=$(find $LOG_DIR -name '*.log' -mtime +$KEEP_DAYS -print -delete | wc -l) 
echo "Deleted $DELETED old log files (older than $KEEP_DAYS days)" 

# Compress logs larger than MAX_SIZE_MB 
for logfile in $LOG_DIR/*.log; do 
	[ -f "$logfile" ] || continue 
	SIZE=$(du -m "$logfile" | cut -f1) 
	if [ "$SIZE" -gt "$MAX_SIZE_MB" ]; then 
		gzip "$logfile" 
		echo "Compressed: $logfile (${SIZE}MB)" 
	fi 
done
 
echo "[$(date)] Log management complete."
