resource "vault_mount" "databases" {
  path                  = "databases"
  type                  = "database"
  description           = "Database authentication automation for dynamic credential generation"
  max_lease_ttl_seconds = 31536000

  depends_on = [vault_mount.kv_enablement]
}

resource "vault_database_secret_backend_connection" "pgsql" {
  backend       = vault_mount.databases.path
  name          = "postgres"
  allowed_roles = ["app1"]

  postgresql {
    connection_url    = "postgresql://{{username}}:{{password}}@${var.postgres_host}:${var.postgres_port}/postgres?sslmode=${var.postgres_sslmode}"
    username          = var.postgres_user
    password          = var.postgres_password
    username_template = "{{.RoleName}}-{{unix_time}}-{{random 8}}"
  }

}

resource "vault_database_secret_backend_role" "app1" {
  backend = vault_mount.databases.path
  name    = "app1"
  db_name = vault_database_secret_backend_connection.pgsql.name
  creation_statements = [
    "CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}' IN ROLE \"app1\";",
    "ALTER ROLE \"{{name}}\" SET ROLE \"app1\";",
  ]
  revocation_statements = [
    "DROP ROLE IF EXISTS \"{{name}}\";",
  ]
  default_ttl = 3600
  max_ttl     = 3600

}