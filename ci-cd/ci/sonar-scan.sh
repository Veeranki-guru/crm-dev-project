#!/bin/bash

set -e

echo "Starting SonarQube scan..."

sonar-scanner \
    -Dsonar.projectKey=crm-dev \
    -Dsonar.projectName=crm-dev \
    -Dsonar.sources=backend \
    -Dsonar.tests=backend/tests

echo "SonarQube scan completed."