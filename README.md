# To take the backup and restore

1. Create a folder called `backups`

2. Need to create file called .env.sh file with bellow values

```bash
# BACKUP ENVs
BACKUP_DB_USER="user_name"
BACKUP_DB_NAME="DB Name"
BACKUP_RESTORE_DB_HOST="Host of target machine"
BACKUP_DB_PORT=5432
BACKUP_PGPASSWORD='target machine users password'
BACKUP_DIR="folder path to save the backup file"

# RESTORE ENVs
RESTORE_DB_USER="User name"
RESTORE_DB_NAME="DB name"
RESTORE_DB_HOST="localhost"
RESTORE_DB_PORT=5432
RESTORE_PGPASSWORD='user password'
```

3. run script to take backup. 

```bash
 sudo sh ./backup_and_restore.sh
```
