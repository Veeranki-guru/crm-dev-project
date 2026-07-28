#!/bin/bash

set -e

LOG_FILE="/tmp/quality-gate.log"

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
echo "     SonarQube Quality Gate Check"
echo "========================================="

# SonarQube Configuration
SONAR_HOST_URL="http://localhost:9000"
SONAR_PROJECT_KEY="crm-dev"
SONAR_TOKEN="YOUR_SONAR_TOKEN"

echo "Waiting for SonarQube analysis..."
sleep 20

STATUS=$(curl -s -u "$SONAR_TOKEN:" \
"$SONAR_HOST_URL/api/qualitygates/project_status?projectKey=$SONAR_PROJECT_KEY" \
| grep -o '"status":"[^"]*"' | cut -d'"' -f4)

if [ "$STATUS" = "OK" ]; then
    echo ""
    echo "========================================="
    echo " Quality Gate PASSED"
    echo "========================================="
    exit 0
elif [ "$STATUS" = "ERROR" ]; then
    echo ""
    echo "========================================="
    echo " Quality Gate FAILED"
    echo "========================================="
    exit 1
else
    echo ""
    echo "========================================="
    echo " Unable to determine Quality Gate status"
    echo "Status: $STATUS"
    echo "========================================="
    exit 1
fi