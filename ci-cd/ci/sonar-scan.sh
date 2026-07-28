#!/bin/bash

set -e

LOG_FILE="/tmp/sonar-scan.log"

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
echo "     SonarQube Code Analysis Started"
echo "========================================="

# Check project directory
if [ ! -f "package.json" ]; then
    echo "ERROR: package.json not found!"
    echo "Run this script from the project root directory."
    exit 1
fi

# Check Sonar Scanner
if ! command -v sonar-scanner &>/dev/null; then
    echo "ERROR: Sonar Scanner is not installed."
    exit 1
fi

# SonarQube Configuration
SONAR_HOST_URL="http://localhost:9000"
SONAR_TOKEN="YOUR_SONAR_TOKEN"

echo "Running SonarQube Scan..."

sonar-scanner \
  -Dsonar.projectKey=crm-dev \
  -Dsonar.projectName="CRM Dev" \
  -Dsonar.projectVersion=1.0 \
  -Dsonar.sources=. \
  -Dsonar.sourceEncoding=UTF-8 \
  -Dsonar.host.url=$SONAR_HOST_URL \
  -Dsonar.token=$SONAR_TOKEN \
  &>>"$LOG_FILE"

VALIDATE $? "SonarQube Analysis"

echo ""
echo "========================================="
echo " SonarQube Analysis Completed"
echo "========================================="

echo "View Report:"
echo "$SONAR_HOST_URL/dashboard?id=crm-dev"