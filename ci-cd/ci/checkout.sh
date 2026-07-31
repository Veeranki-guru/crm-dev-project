#!/bin/bash

set -e

LOG_FILE="/tmp/checkout.log"

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
echo "      Source Code Checkout Started"
echo "========================================="

REPO_URL="https://github.com/Veeranki-guru/crm-dev-project.git"
PROJECT_DIR="/opt/crm-dev"

# Install Git if missing
if ! command -v git &>/dev/null; then
    echo "Git is not installed."
    exit 1
fi

if [ -d "$PROJECT_DIR/.git" ]; then
    echo "Repository already exists."

    cd "$PROJECT_DIR"

    git pull origin main &>>"$LOG_FILE"
    VALIDATE $? "Git Pull"

else
    echo "Cloning Repository..."

    git clone "$REPO_URL" "$PROJECT_DIR" &>>"$LOG_FILE"
    VALIDATE $? "Git Clone"
fi

echo ""
echo "Current Commit:"
git -C "$PROJECT_DIR" log -1 --oneline

echo ""
echo "========================================="
echo " Source Code Checkout Completed"
echo "========================================="