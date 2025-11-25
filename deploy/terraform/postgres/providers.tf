terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.0"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.22"
    }
  }
}

provider "postgresql" {
  host            = var.postgres_host
  port            = var.postgres_port
  database        = var.postgres_database
  username            = var.postgres_user
  password        = var.postgres_password
  sslmode         = var.postgres_sslmode
  connect_timeout = 15
}