# main.tf

# Initialize Terraform configuration
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {
  host = "npipe:////.//pipe//docker_engine"
}

# Define Docker network
resource "docker_network" "wordpress_network" {
  name = "wordpress_network_terraform"
}

# Define MySQL container
resource "docker_container" "mysql" {
  name  = "mysql-container-terraform"
  image = "mysql:latest"
  env   = [
    "MYSQL_ROOT_PASSWORD=root_password",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=wordpress",
    "MYSQL_PASSWORD=wordpress_password",
  ]
  ports {
    internal = 3306
    external = 3306
  }
  networks_advanced {
    name = docker_network.wordpress_network.name
  }
}

# Define WordPress container
resource "docker_container" "wordpress" {
  name  = "wordpress_container_terraform"
  image = "wordpress:latest"
  env   = [
    "WORDPRESS_DB_HOST=mysql-container-terraform",
    "WORDPRESS_DB_USER=wordpress",
    "WORDPRESS_DB_PASSWORD=wordpress_password",
    "WORDPRESS_DB_NAME=wordpress",
  ]
  ports {
    internal = 80
    external = 8000
  }
  networks_advanced {
    name = docker_network.wordpress_network.name
  }
}

# Execute shell command to build backup image
resource "null_resource" "build_backup_image" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "cd && docker build -f Dockerfile.backup -t backup_image:latest ."
  }
}

variable "backup_host_path" {
  type = string
  default = "C:/Users/Mudra/Desktop/wordpress-terraform-docker/backup" # Add your backups path
}
# Define backup container
resource "docker_container" "backup" {
  name  = "backup_container"
  image = "backup_image:latest"
  env = [ 
    "MYSQL_ROOT_PASSWORD=root_password",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=wordpress",
    "MYSQL_PASSWORD=wordpress_password",
    "MYSQL_HOST=mysql-container-terraform",
    "BACKUP_DIR=/backup"
    ]
  volumes {
    # Host path volume
    host_path = var.backup_host_path
    read_only = false
    container_path = "/backup"
  }
  networks_advanced {
    name = docker_network.wordpress_network.name
  }
  depends_on = [null_resource.build_backup_image, docker_container.mysql]
}