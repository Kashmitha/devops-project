#!/bin/bash
# project_report.sh - Generate a project summary

cd ~/devops-project
echo '====================================================='
echo '	AutoDeploy Pipeline - Project Report'
echo '====================================================='
echo "Date: $(date)"
echo "Project: $(basename $PWD)"
echo "Git branch: $(git rev-list --count HEAD)"
echo "Total commits: $(git tag | wc -l)"
echo "Tags / Releases: $(find scripts/ -name '*.sh' | wc -l)"
echo "Shell scripts: $(find config/ -type f | wc -l)"
echo "Project size: $(du -sh . --exclude=.git | cut -f1)"
echo ''
echo '--- Commit History ---'
git log --oneline
echo '============================================='
