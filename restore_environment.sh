#!/bin/bash
BACKUP_FILE_PATH="$1"
# Bring up the new environment
docker-compose -f docker-compose-restore.yml up -d --build

BACKUP_FILENAME="backup_$(date +%Y%m%d_%H%M%S).sql"

docker cp $BACKUP_FILE_PATH mysql-container-new:/$BACKUP_FILENAME

# Restore the database backup
docker exec -i  mysql-container-new sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE"' < $BACKUP_FILE_PATH

# Check if restoration was successful
if [ $? -eq 0 ]; then
    echo "Database restoration completed successfully"
else
    echo "Database restoration failed"
fi
