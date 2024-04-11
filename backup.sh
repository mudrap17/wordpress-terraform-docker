#!/bin/bash

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Generate backup filename with timestamp
BACKUP_FILENAME="backup_$(date +%Y%m%d_%H%M%S).sql"

# Grant necessary privileges to the MySQL user
#mysql -u "$MYSQL_USER" -p "$MYSQL_PASSWORD" -e "GRANT SELECT, SHOW VIEW, LOCK TABLES ON $DATABASE_NAME.* TO '$MYSQL_USER'@'localhost';"

# Perform database backup
mysqldump -h "$MYSQL_HOST" -u root -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE" > "$BACKUP_DIR/$BACKUP_FILENAME"

# Check if backup was successful
if [ $? -eq 0 ]; then
    echo "Database backup completed successfully: $BACKUP_FILENAME"
else
    echo "Database backup failed"
fi
