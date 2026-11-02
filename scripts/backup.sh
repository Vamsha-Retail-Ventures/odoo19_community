#!/usr/bin/env bash
# ==============================================================================
# Vamsha Community - PostgreSQL & Odoo Database Backup Script
# Usage: ./scripts/backup.sh [database_name]
# ==============================================================================
set -euo pipefail

# Directory where backups will be stored
BACKUP_DIR="$(pwd)/backups"
TIMESTAMP="$(date +'%Y%m%d_%H%M%S')"
CONTAINER_DB_NAME="vamsha-odoo19-community-db"

mkdir -p "${BACKUP_DIR}"

# Determine DB user and target database
DB_USER="${POSTGRES_USER:-odoo}"
DB_NAME="${1:-${POSTGRES_DB:-postgres}}"

OUTPUT_FILE="${BACKUP_DIR}/${DB_NAME}_${TIMESTAMP}.sql.gz"

echo "=========================================================="
echo " Starting Backup for database: ${DB_NAME}"
echo " Container: ${CONTAINER_DB_NAME}"
echo "=========================================================="

# Check if container is running
if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_DB_NAME}$"; then
  echo "Error: Container ${CONTAINER_DB_NAME} is not running."
  echo "Please start your stack with 'docker compose up -d' before backing up."
  exit 1
fi

echo "Dumping database '${DB_NAME}'..."
docker exec -t "${CONTAINER_DB_NAME}" pg_dump -U "${DB_USER}" -d "${DB_NAME}" | gzip > "${OUTPUT_FILE}"

echo " Backup successfully created at:"
echo "   ${OUTPUT_FILE}"
echo " File size: $(du -h "${OUTPUT_FILE}" | cut -f1)"
echo "=========================================================="
