#!/bin/bash

set -e

LOG_FILE="/tmp/health-check.log"

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
echo "      Application Health Check"
echo "========================================="

# Application URL
APP_URL="http://localhost:8080"

echo "Checking application health..."

HTTP_STATUS=$(curl -o /dev/null -s -w "%{http_code}" "$APP_URL")

if [ "$HTTP_STATUS" -eq 200 ]; then
    echo "Application is Healthy"
    VALIDATE 0 "Health Check"
else
    echo "Application is Unhealthy (HTTP Status: $HTTP_STATUS)"
    VALIDATE 1 "Health Check"
fi

echo ""
echo "========================================="
echo " Health Check Completed"
echo "========================================="