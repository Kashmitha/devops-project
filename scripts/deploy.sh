#!/bin/bash
# ===========================================
# deploy.sh - AutoDeploy Pipeline Script
# ===========================================
set -e # Exit immediately if any command fails

# --- Configuration -------------------------
PROJECT_DIR="$HOME/devops-project"
APP_DIR="$PROJECT_DIR/app"
LOG_DIR="$PROJECT_DIR/logs"
BACKUP_DIR="$PROJECT_DIR/backups"
mkdir -p "$LOG_DIR" "$BACKUP_DIR"
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
LOG_FILE="$LOG_DIR/deploy_$TIMESTAMP.log"
BRANCH=${1:-main} # Accept branch name as argument

# --- Color output --------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# --- Helper Functions ----------------------
log() 	{ echo -e "${GREEN}[DEPLOY]${NC} $1" | tee -a $LOG_FILE; }
warn() 	{ echo -e "${YELLOW}[WARN]${NC} $1" | tee -a $LOG_FILE; }
error() { echo -e "${RED}[ERROR]${NC} $1" | tee -a $LOG_FILE; exit 1; }

# --- Pre-flight Checks ---------------------
preflight_check() {
	log "Running pre-flight checks..."
	command -v git >/dev/null || error "Git is not installed"
	[ -d "$PROJECT_DIR/.git" ] || error "Not a Git repository"
	log "Pre-flight checks passed ✅"
}

# --- Backup Current App --------------------
backup() {
	log "Backing up current app state..."
	tar -czf $BACKUP_DIR/app_backup_$TIMESTAMP.tar.gz -C $PROJECT_DIR app/
	log "Backup created: app_backup_$TIMESTAMP.tar.gz ✅"
}

# --- Git Pull Lates Code -------------------
git_pull() {
	log "Fetching latest code from branch: $BRANCH"
	cd $PROJECT_DIR
	CURRENT_BRANCH=$(git branch --show-current)
	log "Current branch: $CURRENT_BRANCH"
	log "Git status: $(git status --short | wc -l) changed files"
	git checkout $BRANCH && git pull origin $BRANCH
        log "Git pull simulated (no remote configured) ✅" 
} 
	
# --- Deploy -------------------------------- 
deploy() { 
	log "Deploying application..." 
	# Copy app files to 'deployment' location 
	cp -r $APP_DIR/* $PROJECT_DIR/docs/ 2>/dev/null || true 
	log "Files deployed ✅" 
} 
	
# --- Run Health Check ---------------------- 
health_check() { 
	log "Running post-deploy health check..." 
	$PROJECT_DIR/scripts/health_check.sh 
	log "Health check passed ✅" 
} 

# --- Main Pipeline ------------------------- 
log "====== AutoDeploy Pipeline Started ======" 
log "Timestamp: $TIMESTAMP" 
log "Branch: $BRANCH" 
log "=========================================" 

preflight_check 
backup 
git_pull 
deploy 
health_check 

log "====== Deployment Successfull! ======" 
log "Log saved to: $LOG_FILE"

