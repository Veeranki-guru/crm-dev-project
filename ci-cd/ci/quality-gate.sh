#!/bin/bash

set -e

echo "Checking SonarQube Quality Gate..."

curl -s \
  -u "$SONAR_TOKEN:" \
  "http://localhost:9000/api/qualitygates/project_status?projectKey=crm-dev" \
  > quality-gate.json

STATUS=$(python3 -c "import json; print(json.load(open('quality-gate.json'))['projectStatus']['status'])")

echo "Quality Gate Status: $STATUS"

if [ "$STATUS" != "OK" ]; then
    echo "Quality Gate failed."
    exit 1
fi

echo "Quality Gate passed."