# wordpress-terraform-docker

## Objectives
+ Create a dockerized environment with a Wordpress website and a database.
+ Create a backup container responsible for taking database backups at regular intervals.
+ Create a Terraform script for automated infrastructure building.
+ Create a new environment to restore database from backup and validate changes in new Wordpress website.

### Build infrastructure with docker-compose file
This will build the Wordpress website, a MySQL database and a backup container:
``` 
docker compose up
```

### For testing the backup
1. Spin up a terraform environment, which includes the Wordpress website, MySQL database and a backup container
```
terraform init
terraform plan
terraform apply
```
2. Make changes(add posts,comments) to the Wordpress website hosted at:
```
http://localhost:8000
```
3. Run a new environment from the restored backup in git bash
```
./restore_environment /backup/backup_timestamp.sql
```
4. Validate restored backup with new Wordpress website hosted at:
```
http://localhost:8080/
```


