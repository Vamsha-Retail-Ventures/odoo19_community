#!/usr/bin/env bash
# ==============================================================================
# Vamsha Community - PostgreSQL Database Restore Script
# Usage: ./scripts/restore.sh <path_to_backup_file> [target_database_name]
# ==============================================================================
set -euo pipefail

CONTAINER_DB_NAME="vamsha-odoo19-community-db"

if [ $# -lt 1 ]; then
  echo "Usage: $0 <path_to_backup_file.sql.gz or .sql> [target_database_name]"
  exit 1
fi

BACKUP_FILE="$1"
DB_USER="${POSTGRES_USER:-odoo}"
DB_NAME="${2:-${POSTGRES_DB:-postgres}}"

if [ ! -f "${BACKUP_FILE}" ]; then
  echo "Error: Backup file '${BACKUP_FILE}' not found."
  exit 1
fi

if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_DB_NAME}$"; then
  echo "Error: Container ${CONTAINER_DB_NAME} is not running."
  echo "Please start your stack with 'docker compose up -d' before restoring."
  exit 1
fi

echo "=========================================================="
echo " Starting Database Restore"
echo " Backup File: ${BACKUP_FILE}"
echo " Target DB:   ${DB_NAME}"
echo " Container:   ${CONTAINER_DB_NAME}"
echo "=========================================================="

echo "Restoring database..."
if [[ "${BACKUP_FILE}" == *.gz ]]; then
  gunzip -c "${BACKUP_FILE}" | docker exec -i "${CONTAINER_DB_NAME}" psql -U "${DB_USER}" -d "${DB_NAME}"
else
  cat "${BACKUP_FILE}" | docker exec -i "${CONTAINER_DB_NAME}" psql -U "${DB_USER}" -d "${DB_NAME}"
fi

echo " Database restore completed successfully into '${DB_NAME}'!"
echo "=========================================================="
