# wordpress-terraform-docker

## Objectives
+ Create a dockerized environment with a Wordpress website and a database.
+ Create a backup container responsible for taking database backups at regular intervals.
+ Create a Terraform script for automated infrastructure building.
+ Create a new environment to restore database from backup and validate changes in new Wordpress website.

### Prerequisites
+ You need to have Docker installed: [Install Docker guide](https://docs.docker.com/get-docker/)
+ You need to have Terraform installed: [Install Terraform guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
  
### Important files
- ``main.tf`` - The terraform infrastructure build file
+ ``docker-compose.yml`` - The docker infrastructure build file
- ``Dockerfile.backup`` - The dockerfile to build backup container image
+ ``backup.sh`` - The bash script to take the database backup
- ``run_backup.sh`` - The bash script to run the backup script at regular intervals
+ ``docker-compose-restore.yml`` - The docker restored infrastructure file
- ``restore_environment.sh`` - The bash script to restore the environment with the backup file provided

### Build infrastructure with docker-compose file
1. Open Docker Desktop and verify it works properly
2. Clone this repository into your desired folder and run the following commands in the root directory
3. Run the ``docker-compose.yml`` file to build the Wordpress website, associated MySQL database and a backup container:
``` 
docker compose up
```
4. To stop the containers, run this command:
```
docker compose down
```

### For testing the backup


1. Spin up a terraform environment, which includes the Wordpress website, MySQL database and a backup container (answer yes when prompted to approve tasks):
```
terraform init
terraform plan
terraform apply
```
</br>   

2. Make changes(add posts,comments) to the Wordpress website hosted at:
```
http://localhost:8000
```
</br> 

3. The database backup is taken every 2 minutes. Check the backup folder in the root directory and identify the backup file with the format: 
```
backup/backup_timestamp.sql
```
</br> 

4. Run a new environment from the restored backup in git bash. Use the latest backup file to pass as an argument:
```
./restore_environment /backup/backup_timestamp.sql
```
</br>

5. Validate restored backup with new Wordpress website hosted at:
```
http://localhost:8080/
```
6. To stop the terraform infrastructure, run this command:
```
terraform destroy
```
