#!/bin/bash
# ===========================================
# health_check.sh - System Health Monitor
# Author: Kashmitha
# ===========================================

# Variables
LOG_DIR="$HOME/devops-project/logs"
LOG_FILE="$LOG_DIR/health_$(date +%Y%m%d).log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Create log directory if not exist
mkdir -p "$LOG_DIR"

# Function to log message
log() {
  echo "[$TIMESTAMP] $1" | tee -a "$LOG_FILE"
}

# CPU and Memory
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
MEM=$(free -h | awk '/Mem:/ {print $3"/"$2}')

log "CPU Usage: ${CPU}%"
log "Memory Usage: $MEM"

# Disk Space
DISK=$(df -h / | awk 'NR==2 {print $5}')
log "Disk Usage (/): $DISK"

# Check if disk usage > 80%
DISK_NUM=$(echo "$DISK" | tr -d '%')

if [ "$DISK_NUM" -gt 80 ]; then
  log "WARNING: Disk usage is above 80%!"
else
  log "Disk usage is OK."
fi

log "==========Health Check Complete=========="
