#!/bin/bash

set -e

HEALTH_URL="$1"

if [ -z "$HEALTH_URL" ]; then
    HEALTH_URL="http://localhost:5000/health"
fi

MAX_RETRIES=30
RETRY_INTERVAL=5

echo "======================================"
echo "Application Health Check"
echo "======================================"

echo "URL: $HEALTH_URL"

for ((i=1; i<=MAX_RETRIES; i++))
do

    echo "Health check attempt $i/$MAX_RETRIES..."

    HTTP_STATUS=$(curl \
        --silent \
        --output /dev/null \
        --write-out "%{http_code}" \
        "$HEALTH_URL" || true)

    if [ "$HTTP_STATUS" = "200" ]; then
        echo "Application is healthy."
        echo "HTTP Status: $HTTP_STATUS"
        exit 0
    fi

    echo "Application not ready."
    echo "HTTP Status: $HTTP_STATUS"

    sleep "$RETRY_INTERVAL"

done

echo "ERROR: Application health check failed."

exit 1