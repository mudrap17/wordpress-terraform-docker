# wordpress-terraform-docker

## Build infrastructure with docker-compose file
``` 
docker compose up
```

## For testing the backup
Spin up a terraform environment, which includes the backup container
```
terraform init
terraform plan
terraform apply
```
Run a new environment from the restored backup in git bash
```
./restore_environment /backup/backup_timestamp.sql
```


