#!/bin/bash

set -e

LOG_FILE="/tmp/deploy.log"

VALIDATE() {
    if [ $1 -eq 0 ]; then
        echo "$2 ... SUCCESS"
    else
        echo "$2 ... FAILURE"
        echo "Check log: $LOG_FILE"
        exit 1
    fi
}

echo "========================================="
echo "      Application Deployment Started"
echo "========================================="

APP_DIR="/opt/crm-dev"
APP_NAME="crm-dev"

# Check application directory
if [ ! -d "$APP_DIR" ]; then
    echo "ERROR: Application directory not found!"
    exit 1
fi

cd "$APP_DIR"

echo "Installing dependencies..."

npm install &>>"$LOG_FILE"
VALIDATE $? "NPM Install"

echo "Stopping existing application..."

pkill -f "node" || true

echo "Starting application..."

nohup npm start > app.log 2>&1 &

sleep 10

if pgrep -f "node" >/dev/null; then
    echo "Application started successfully."
    VALIDATE 0 "Application Deployment"
else
    VALIDATE 1 "Application Deployment"
fi

echo ""
echo "========================================="
echo " Deployment Completed Successfully"
echo "========================================="