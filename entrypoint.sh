#!/bin/bash

/opt/mssql/bin/sqlservr & 

until /opt/mssql-tools18/bin/sqlcmd -S . -U SA -P "${MSSQL_SA_PASSWORD}" -C -Q "SELECT 1" > /dev/null 2>&1
do
  echo -n "...waiting..."
  sleep 1
done

echo "SQL Server is up and running."

for BACKUP_FILE in "/var/opt/mssql/backup"/*; do   
  echo "Restoring database from $BACKUP_FILE..."

  LOGICAL_NAMES=$(/opt/mssql-tools18/bin/sqlcmd -S . -U SA -P "${MSSQL_SA_PASSWORD}" -C -Q \
    "RESTORE FILELISTONLY FROM DISK = '$BACKUP_FILE'" | grep -Ei 'MDF|LDF' | awk '{print $1}')
  LOGICAL_DATA_FILE=$(echo "$LOGICAL_NAMES" | head -n 1 | tr -d ' ')
  LOGICAL_LOG_FILE=$(echo "$LOGICAL_NAMES" | tail -n 1 | tr -d ' ')

  DATABASE_NAME=$(basename "$BACKUP_FILE")

  /opt/mssql-tools18/bin/sqlcmd -S . -U SA -P "${MSSQL_SA_PASSWORD}" -C -Q "
    RESTORE DATABASE [$DATABASE_NAME]
    FROM DISK = '$BACKUP_FILE'
    WITH MOVE '$LOGICAL_DATA_FILE' TO '/var/opt/mssql/data/$DATABASE_NAME.mdf',
    MOVE '$LOGICAL_LOG_FILE' TO '/var/opt/mssql/data/$DATABASE_NAME.ldf'
  "

  echo "Database $DATABASE_NAME restored successfully."
done

tail -f /dev/null
