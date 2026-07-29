#!/bin/bash

set -e

# ============================================================
# Nexus Configuration
# ============================================================

NEXUS_VERSION="3.94.1-06"
NEXUS_USER="nexus"
NEXUS_HOME="/opt/nexus"
NEXUS_TAR="nexus-${NEXUS_VERSION}-unix.tar.gz"
NEXUS_URL="https://download.sonatype.com/nexus/3/${NEXUS_TAR}"

echo "=========================================="
echo "Nexus Installation Started"
echo "=========================================="

# ============================================================
# 1. Check if Nexus is already installed
# ============================================================

if [ -d "$NEXUS_HOME" ]; then

    echo "Nexus is already installed at $NEXUS_HOME"
    echo "Skipping Nexus installation."

    if systemctl is-active --quiet nexus; then
        echo "Nexus service is already running."
    else
        echo "Nexus is installed but service is not running."
        echo "You can start it using:"
        echo "sudo systemctl start nexus"
    fi

    exit 0
fi

# ============================================================
# 2. Install required packages
# ============================================================

echo "Installing required packages..."

sudo dnf install -y java-21-openjdk wget tar

# ============================================================
# 3. Create Nexus user
# ============================================================

if id "$NEXUS_USER" &>/dev/null; then
    echo "User $NEXUS_USER already exists."
else
    echo "Creating user $NEXUS_USER..."
    sudo useradd --system --no-create-home "$NEXUS_USER"
fi

# ============================================================
# 4. Download Nexus
# ============================================================

cd /opt

echo "Downloading Nexus ${NEXUS_VERSION}..."

if [ -f "$NEXUS_TAR" ]; then
    echo "$NEXUS_TAR already exists."
else
    sudo wget "$NEXUS_URL"
fi

# ============================================================
# 5. Check downloaded file
# ============================================================

if [ ! -f "/opt/$NEXUS_TAR" ]; then
    echo "ERROR: Nexus download failed."
    exit 1
fi

echo "Nexus download successful."

# ============================================================
# 6. Extract Nexus
# ============================================================

echo "Extracting Nexus..."

sudo tar -xzf "/opt/$NEXUS_TAR"

# ============================================================
# 7. Find extracted Nexus directory
# ============================================================

NEXUS_DIR=$(find /opt -maxdepth 1 -type d -name "nexus-*" ! -name "nexus" | head -1)

if [ -z "$NEXUS_DIR" ]; then
    echo "ERROR: Nexus extracted directory not found."
    exit 1
fi

echo "Nexus extracted directory found:"
echo "$NEXUS_DIR"

# ============================================================
# 8. Rename Nexus directory
# ============================================================

if [ -d "$NEXUS_HOME" ]; then
    echo "ERROR: $NEXUS_HOME already exists."
    exit 1
fi

sudo mv "$NEXUS_DIR" "$NEXUS_HOME"

# ============================================================
# 9. Set ownership
# ============================================================

sudo chown -R "$NEXUS_USER:$NEXUS_USER" "$NEXUS_HOME"

# ============================================================
# 10. Configure Nexus
# ============================================================

sudo mkdir -p /opt/sonatype-work

sudo chown -R "$NEXUS_USER:$NEXUS_USER" /opt/sonatype-work

# ============================================================
# 11. Create Nexus systemd service
# ============================================================

sudo tee /etc/systemd/system/nexus.service > /dev/null <<EOF
[Unit]
Description=Nexus Repository Manager
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
User=$NEXUS_USER
Group=$NEXUS_USER
ExecStart=$NEXUS_HOME/bin/nexus start
ExecStop=$NEXUS_HOME/bin/nexus stop
Restart=on-abort
TimeoutSec=600

[Install]
WantedBy=multi-user.target
EOF

# ============================================================
# 12. Enable and start Nexus
# ============================================================

echo "Starting Nexus service..."

sudo systemctl daemon-reload
sudo systemctl enable nexus
sudo systemctl start nexus

# ============================================================
# 13. Check Nexus service
# ============================================================

sleep 10

if systemctl is-active --quiet nexus; then
    echo "=========================================="
    echo "Nexus installed successfully."
    echo "Nexus service is running."
    echo "=========================================="
else
    echo "ERROR: Nexus service failed to start."
    echo "Check logs using:"
    echo "sudo systemctl status nexus"
    echo "sudo journalctl -u nexus -n 100 --no-pager"
    exit 1
fi