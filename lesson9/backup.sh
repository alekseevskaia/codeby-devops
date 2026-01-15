#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/opt/mysql_backup"
DB_NAME="company_db"
USER="root"

mysqldump -u"$USER" "$DB_NAME" > "$BACKUP_DIR/company_db_$DATE.sql"

(ls -t "$BACKUP_DIR"/company_db_*.sql 2>/dev/null || true) | tail -n +25 | xargs rm -f 2>/dev/null || true

rsync -avz --delete "$BACKUP_DIR/" vagrant@192.168.56.11:/opt/store-provision/mysql/ >/dev/null 2>&1

echo "[$(date)] Backup completed: company_db_$DATE.sql" >> /var/log/mysql_backup.log