#!/bin/bash
set -euo pipefail

BACKUP_DIR="$HOME/mission10/backups"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/mysql_backup_$TIMESTAMP.sql"

mkdir -p "$BACKUP_DIR"

source "$HOME/mission10/.env"

docker exec \
  -e MYSQL_USER="$MYSQL_USER" \
  -e MYSQL_PASSOWRD="$MYSQL_PASSWORD" \
  -e MYSQL_DATABASE="$MYSQL_DATABASE" \
  mission10-mysql sh -c \
  'exec mysqldump --no-tablespaces  -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE"' \
  > "$BACKUP_FILE"

echo "Database backup saved to: $BACKUP_FILE"
