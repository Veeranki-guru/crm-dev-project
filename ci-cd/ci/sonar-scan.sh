#!/bin/bash

set -e

echo "Starting SonarQube scan..."

sonar-scanner \
  -Dsonar.projectKey=crm-dev \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.token="$SONAR_TOKEN"

echo "SonarQube scan completed."