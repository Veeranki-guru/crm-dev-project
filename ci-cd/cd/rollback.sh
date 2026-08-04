#!/bin/bash

set -e

########################################
# CRM Rollback Script
########################################

APP_NAME="crm-dev"
DEPLOY_DIR="/var/www/crm-dev"
BACKUP_DIR="/var/www/backups"

echo "======================================="
echo " Starting Rollback"
echo "======================================="

# Check backup directory
if [ ! -d "$BACKUP_DIR" ]; then
    echo "ERROR: Backup directory not found."
    exit 1
fi

# Get latest backup
LATEST_BACKUP=$(ls -dt ${BACKUP_DIR}/${APP_NAME}-* 2>/dev/null | head -1)

if [ -z "$LATEST_BACKUP" ]; then
    echo "ERROR: No backup available for rollback."
    exit 1
fi

echo "Latest Backup : $LATEST_BACKUP"

# Remove failed deployment
echo "Removing failed deployment..."

sudo rm -rf "$DEPLOY_DIR"

# Restore backup
echo "Restoring previous version..."

sudo cp -r "$LATEST_BACKUP" "$DEPLOY_DIR"

# Set permissions
sudo chown -R www-data:www-data "$DEPLOY_DIR" 2>/dev/null || true

# Restart application
echo "Restarting application..."

if command -v pm2 >/dev/null 2>&1; then
    pm2 restart all
elif systemctl list-units --type=service | grep -q crm; then
    sudo systemctl restart crm
elif systemctl list-units --type=service | grep -q nginx; then
    sudo systemctl restart nginx
fi

echo "======================================="
echo " Rollback Completed Successfully"
echo "======================================="