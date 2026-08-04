# #!/bin/bash

# set -e

# # ============================================================
# # PostgreSQL Configuration
# # ============================================================

# PG_VERSION="15"

# echo "=========================================="
# echo "PostgreSQL ${PG_VERSION} Installation"
# echo "=========================================="

# # ============================================================
# # 1. Check if PostgreSQL is already installed
# # ============================================================

# if command -v psql >/dev/null 2>&1; then
#     echo "PostgreSQL is already installed."

#     psql --version

#     if systemctl is-active --quiet postgresql-15; then
#         echo "PostgreSQL service is already running."
#     else
#         echo "PostgreSQL is installed but service is not running."
#     fi

#     exit 0
# fi

# # ============================================================
# # 2. Install PostgreSQL Repository
# # ============================================================

# echo "Installing PostgreSQL official repository..."

# sudo dnf install -y \
#     https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-x86_64/pgdg-redhat-repo-latest.noarch.rpm

# # ============================================================
# # 3. Disable RHEL PostgreSQL module
# # ============================================================

# echo "Disabling default PostgreSQL module..."

# sudo dnf -qy module disable postgresql

# # ============================================================
# # 4. Install PostgreSQL 15
# # ============================================================

# echo "Installing PostgreSQL ${PG_VERSION}..."

# sudo dnf install -y postgresql15-server postgresql15

# # ============================================================
# # 5. Initialize PostgreSQL database
# # ============================================================

# echo "Initializing PostgreSQL database..."

# if [ ! -f /var/lib/pgsql/15/data/PG_VERSION ]; then
#     sudo /usr/pgsql-15/bin/postgresql-15-setup initdb
# else
#     echo "PostgreSQL database is already initialized."
# fi

# # ============================================================
# # 6. Enable PostgreSQL service
# # ============================================================

# echo "Enabling PostgreSQL service..."

# sudo systemctl enable postgresql-15

# # ============================================================
# # 7. Start PostgreSQL service
# # ============================================================

# echo "Starting PostgreSQL service..."

# sudo systemctl start postgresql-15

# # ============================================================
# # 8. Check PostgreSQL status
# # ============================================================

# if systemctl is-active --quiet postgresql-15; then
#     echo "=========================================="
#     echo "PostgreSQL installed successfully."
#     echo "=========================================="

#     sudo systemctl status postgresql-15 --no-pager

#     echo ""
#     echo "PostgreSQL version:"
#     psql --version

# else
#     echo "ERROR: PostgreSQL failed to start."

#     echo "Check service status:"
#     echo "sudo systemctl status postgresql-15"

#     echo "Check logs:"
#     echo "sudo journalctl -u postgresql-15 -n 100 --no-pager"

#     exit 1
# fi