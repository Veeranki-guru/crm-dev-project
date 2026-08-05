#!/bin/bash

set -e

########################################
# CRM Rollback Script
########################################

APP_NAME="crm-dev"

DEPLOY_DIR="/var/www/crm-dev-project"
BACKUP_DIR="/opt/crm-dev-backups"

echo "======================================="
echo " Starting Rollback"
echo "======================================="


########################################
# Check backup directory
########################################

if [ ! -d "$BACKUP_DIR" ]; then
    echo "ERROR: Backup directory not found: $BACKUP_DIR"
    exit 1
fi


########################################
# Find latest backup
########################################

LATEST_BACKUP=$(ls -dt ${BACKUP_DIR}/${APP_NAME}-*.tar.gz 2>/dev/null | head -1)


if [ -z "$LATEST_BACKUP" ]; then
    echo "ERROR: No backup available for rollback."
    exit 1
fi


echo "Latest Backup: $LATEST_BACKUP"


########################################
# Stop application
########################################

echo "Stopping CRM service..."

sudo systemctl stop crm-dev || true


########################################
# Remove failed deployment
########################################

echo "Removing failed deployment..."

sudo rm -rf "$DEPLOY_DIR"

sudo mkdir -p "$DEPLOY_DIR"


########################################
# Restore backup
########################################

echo "Restoring previous version..."

sudo tar \
    -xzf "$LATEST_BACKUP" \
    -C "$DEPLOY_DIR"


########################################
# Permissions
########################################

echo "Updating ownership..."

sudo chown -R ec2-user:ec2-user "$DEPLOY_DIR"


########################################
# Start application
########################################

echo "Starting CRM service..."

sudo systemctl start crm-dev


########################################
# Verify service
########################################

if sudo systemctl is-active --quiet crm-dev
then
    echo "CRM service is running."
else
    echo "ERROR: CRM service failed after rollback."
    sudo systemctl status crm-dev --no-pager
    exit 1
fi


echo "======================================="
echo " Rollback Completed Successfully"
echo "======================================="