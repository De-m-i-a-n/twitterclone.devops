# main.tf

# Configure the Docker provider
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {}

# 1. Create a shared network for the containers
resource "docker_network" "app_network" {
  name = "twitter-app-network"
}

# 2. Define the named volumes
resource "docker_volume" "postgres_data" {
  name = "postgres_data"
}

resource "docker_volume" "static_volume" {
  name = "static_volume"
}

resource "docker_volume" "media_volume" {
  name = "media_volume"
}

# 3. Pull the official Postgres image
resource "docker_image" "postgres_image" {
  name = "postgres:14"
}

# 4. Define the database (db) container
resource "docker_container" "db" {
  name  = "db"
  image = docker_image.postgres_image.image_id

  ports {
    internal = 5432
    external = 5432
  }

  env = [
    "POSTGRES_DB=${var.POSTGRES_DB}",
    "POSTGRES_USER=${var.POSTGRES_USER}",
    "POSTGRES_PASSWORD=${var.POSTGRES_PASSWORD}"
  ]

  mounts {
    type   = "volume"
    source = docker_volume.postgres_data.name
    target = "/var/lib/postgresql/data/"
  }

  networks_advanced {
    name = docker_network.app_network.name
  }
}

# 5. Build the web app image from the Dockerfile
resource "docker_image" "web_image" {
  name = "twitter-web-app:latest"
  build {
    context = "."
  }
}

# 6. Define the web application container
resource "docker_container" "web" {
  name  = "web"
  image = docker_image.web_image.name

  ports {
    internal = 8000
    external = 8000
  }

  # Environment variables for Django app
  env = [
    "POSTGRES_DB=${var.POSTGRES_DB}",
    "POSTGRES_USER=${var.POSTGRES_USER}",
    "POSTGRES_PASSWORD=${var.POSTGRES_PASSWORD}",
    "DATABASE_HOST=${docker_container.db.name}",
    "SECRET_KEY=${var.SECRET_KEY}" # Django-specific settings
  ]

  # Startup command
  command = [
    "sh",
    "-c",
    "./wait-for.sh db 5432 && python manage.py migrate && python manage.py runserver 0.0.0.0:8000"
  ]

  # CORRECTED SYNTAX: Each mount is its own separate block
  mounts {
    type   = "bind"
    source = "${path.cwd}/src/"
    target = "/app/"
  }

  mounts {
    type   = "bind"
    source = "${path.cwd}/wait-for.sh"
    target = "/app/wait-for.sh"
  }

  mounts {
    type   = "volume"
    source = docker_volume.static_volume.name
    target = "/app/staticfiles"
  }

  mounts {
    type   = "volume"
    source = docker_volume.media_volume.name
    target = "/app/mediafiles"
  }

  # Attach to the shared network
  networks_advanced {
    name = docker_network.app_network.name
  }

  # Explicitly define dependency
  depends_on = [docker_container.db]
}
