#!/bin/bash

set -e

LOG_FILE="/tmp/install-postgresql.log"

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
echo "   PostgreSQL Installation Started"
echo "========================================="

# Check root user
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root or with sudo."
    exit 1
fi

echo "Installing PostgreSQL..."

dnf install -y postgresql15-server postgresql15 &>>"$LOG_FILE"
VALIDATE $? "PostgreSQL Installation"

echo "Initializing PostgreSQL Database..."

postgresql-setup --initdb &>>"$LOG_FILE"
VALIDATE $? "Database Initialization"

echo "Enabling PostgreSQL Service..."

systemctl enable postgresql &>>"$LOG_FILE"
VALIDATE $? "Enable PostgreSQL"

echo "Starting PostgreSQL Service..."

systemctl start postgresql &>>"$LOG_FILE"
VALIDATE $? "Start PostgreSQL"

echo ""
echo "PostgreSQL Status:"
systemctl status postgresql --no-pager

echo ""
echo "PostgreSQL Version:"
psql --version

echo ""
echo "========================================="
echo " PostgreSQL Installation Completed"
echo "========================================="