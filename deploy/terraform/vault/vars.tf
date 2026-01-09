variable "vault_address" {
  description = "Vault server address"
  type        = string
  default     = "http://localhost:8200"
}

variable "vault_token" {
  description = "Vault root token"
  type        = string
  sensitive   = true
  default     = "root"
}
variable "postgres_host" {
  description = "PostgreSQL hostname"
  type        = string
  default     = "postgres-rw.postgres.svc.cluster.local"
}

variable "postgres_port" {
  description = "PostgreSQL port"
  type        = number
  default     = 5432
}

variable "postgres_database" {
  description = "PostgreSQL database"
  type        = string
  default     = "postgres"
}

variable "postgres_user" {
  description = "PostgreSQL username"
  type        = string
  default     = "postgres"
}

variable "postgres_password" {
  description = "PostgreSQL password"
  type        = string
  sensitive   = true
  default     = "postgres-password"
}

variable "postgres_sslmode" {
  description = "PostgreSQL SSL mode"
  type        = string
  default     = "disable"
}