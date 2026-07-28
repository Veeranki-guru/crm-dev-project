#!/bin/bash

set -e

LOG_FILE="/tmp/package.log"

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
echo "      Package Build Started"
echo "========================================="

# Check project directory
if [ ! -f "package.json" ]; then
    echo "ERROR: package.json not found!"
    echo "Run this script from the project root directory."
    exit 1
fi

echo "Installing Node.js dependencies..."

npm install &>>"$LOG_FILE"
VALIDATE $? "NPM Install"

echo "Checking for build script..."

if npm run | grep -q "build"; then
    echo "Running application build..."

    npm run build &>>"$LOG_FILE"
    VALIDATE $? "Application Build"
else
    echo "No build script found in package.json."
    echo "Skipping build step."
fi

echo ""
echo "========================================="
echo " Package Build Completed Successfully"
echo "========================================="