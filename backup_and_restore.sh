#!/bin/bash

# Import environment variables for backup
export $(cat .env.sh | grep ^BACKUP_ | xargs)

# Set the PGPASSWORD environment variable for backup
export PGPASSWORD="$BACKUP_PGPASSWORD"

# Function to perform backup
perform_backup() {
    # Generate backup file name
    DATE=$(date +"%Y-%m-%d_%H:%M:%S")
    BACKUP_FILE="$BACKUP_DIR/$BACKUP_DB_NAME"_"$DATE.dump"
    echo "Taking backup started..."
    # Perform backup
    pg_dump -U "$BACKUP_DB_USER" -h "$BACKUP_RESTORE_DB_HOST" -p "$BACKUP_DB_PORT" -d "$BACKUP_DB_NAME" --clean --if-exists -Fc -f "$BACKUP_FILE"

    # Check if the backup was successful
    if [ $? -eq 0 ]; then
        echo "Backup created successfully: ${BACKUP_FILE}"
    else
        echo "Backup failed: ${BACKUP_FILE}"
        exit 1
    fi
}

# Import environment variables for restore
export $(cat .env.sh | grep ^RESTORE_ | xargs)

# Set the PGPASSWORD environment variable for restore
export PGPASSWORD="$RESTORE_PGPASSWORD"

# Function to perform restore
perform_restore() {
    # Perform restore
    LATEST_BACKUP=$(ls -t $BACKUP_DIR/$BACKUP_DB_NAME*.dump | head -n 1)
    if [ -z "$LATEST_BACKUP" ]; then
        echo "No backup file found to restore."
        exit 1
    fi
    echo "Restoration started..."
    pg_restore --username="$RESTORE_DB_USER" -h "$RESTORE_DB_HOST" -p "$RESTORE_DB_PORT" -d "$RESTORE_DB_NAME" --clean --if-exists < "$LATEST_BACKUP"

    # Check if the restore was successful
    if [ $? -eq 0 ]; then
        echo "Restore completed successfully."
    else
        echo "Restore failed."
        exit 1
    fi
}

# Main script
perform_backup
perform_restore
