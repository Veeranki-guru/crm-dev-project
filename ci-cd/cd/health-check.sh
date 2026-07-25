#!/bin/bash

set -e

echo "======================================"
echo "CRM-DEV Health Check"
echo "======================================"


# Application URL
APP_URL="${APP_URL:-http://localhost:5000}"


# Health endpoint
HEALTH_URL="$APP_URL/health"


echo "Checking:"
echo "$HEALTH_URL"


# Send request
HTTP_STATUS=$(curl \
    --silent \
    --output /dev/null \
    --write-out "%{http_code}" \
    "$HEALTH_URL")


if [ "$HTTP_STATUS" = "200" ]
then

    echo "======================================"
    echo "Application is HEALTHY"
    echo "HTTP Status: $HTTP_STATUS"
    echo "======================================"

    exit 0

else

    echo "======================================"
    echo "Application is UNHEALTHY"
    echo "HTTP Status: $HTTP_STATUS"
    echo "======================================"

    exit 1

fi