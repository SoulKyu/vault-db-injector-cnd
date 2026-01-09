resource "null_resource" "postgres_setup" {
  provisioner "local-exec" {
    command = <<-EOT
      PGPASSWORD="${var.postgres_password}" PGSSLMODE="${var.postgres_sslmode}" psql \
        -h ${var.postgres_host} \
        -p ${var.postgres_port} \
        -U ${var.postgres_user} \
        -d postgres \
        -c "CREATE DATABASE app1;"
    EOT
  }

  provisioner "local-exec" {
    command = <<-EOT
      PGPASSWORD="${var.postgres_password}" PGSSLMODE="${var.postgres_sslmode}" psql \
        -h ${var.postgres_host} \
        -p ${var.postgres_port} \
        -U ${var.postgres_user} \
        -d postgres \
        -c "CREATE ROLE app1 WITH NOLOGIN;" 2>/dev/null || true
    EOT
  }

  provisioner "local-exec" {
    command = <<-EOT
      PGPASSWORD="${var.postgres_password}" PGSSLMODE="${var.postgres_sslmode}" psql \
        -h ${var.postgres_host} \
        -p ${var.postgres_port} \
        -U ${var.postgres_user} \
        -d app1 \
        -c "REVOKE ALL ON DATABASE app1 FROM public CASCADE;"
    EOT
  }

  provisioner "local-exec" {
    command = <<-EOT
      PGPASSWORD="${var.postgres_password}" PGSSLMODE="${var.postgres_sslmode}" psql \
        -h ${var.postgres_host} \
        -p ${var.postgres_port} \
        -U ${var.postgres_user} \
        -d app1 \
        -c "GRANT CONNECT ON DATABASE app1 TO app1;"
    EOT
  }

  provisioner "local-exec" {
    command = <<-EOT
      PGPASSWORD="${var.postgres_password}" PGSSLMODE="${var.postgres_sslmode}" psql \
        -h ${var.postgres_host} \
        -p ${var.postgres_port} \
        -U ${var.postgres_user} \
        -d app1 \
        -c "GRANT CREATE, USAGE ON SCHEMA public TO app1;"
    EOT
  }

  provisioner "local-exec" {
    command = <<-EOT
      PGPASSWORD="${var.postgres_password}" PGSSLMODE="${var.postgres_sslmode}" psql \
        -h ${var.postgres_host} \
        -p ${var.postgres_port} \
        -U ${var.postgres_user} \
        -d app1 \
        -c "GRANT TEMPORARY ON DATABASE app1 TO app1;"
    EOT
  }

  provisioner "local-exec" {
    command = <<-EOT
      PGPASSWORD="${var.postgres_password}" PGSSLMODE="${var.postgres_sslmode}" psql \
        -h ${var.postgres_host} \
        -p ${var.postgres_port} \
        -U ${var.postgres_user} \
        -d app1 \
        -c "ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO app1;"
    EOT
  }

  provisioner "local-exec" {
    command = <<-EOT
      PGPASSWORD="${var.postgres_password}" PGSSLMODE="${var.postgres_sslmode}" psql \
        -h ${var.postgres_host} \
        -p ${var.postgres_port} \
        -U ${var.postgres_user} \
        -d postgres \
        -c "REVOKE ALL ON pg_user FROM public;"
    EOT
  }

  provisioner "local-exec" {
    command = <<-EOT
      PGPASSWORD="${var.postgres_password}" PGSSLMODE="${var.postgres_sslmode}" psql \
        -h ${var.postgres_host} \
        -p ${var.postgres_port} \
        -U ${var.postgres_user} \
        -d postgres \
        -c "REVOKE ALL ON pg_roles FROM public;"
    EOT
  }

  provisioner "local-exec" {
    command = <<-EOT
      PGPASSWORD="${var.postgres_password}" PGSSLMODE="${var.postgres_sslmode}" psql \
        -h ${var.postgres_host} \
        -p ${var.postgres_port} \
        -U ${var.postgres_user} \
        -d postgres \
        -c "REVOKE ALL ON pg_group FROM public;"
    EOT
  }

  provisioner "local-exec" {
    command = <<-EOT
      PGPASSWORD="${var.postgres_password}" PGSSLMODE="${var.postgres_sslmode}" psql \
        -h ${var.postgres_host} \
        -p ${var.postgres_port} \
        -U ${var.postgres_user} \
        -d postgres \
        -c "REVOKE ALL ON pg_authid FROM public;"
    EOT
  }

  provisioner "local-exec" {
    command = <<-EOT
      PGPASSWORD="${var.postgres_password}" PGSSLMODE="${var.postgres_sslmode}" psql \
        -h ${var.postgres_host} \
        -p ${var.postgres_port} \
        -U ${var.postgres_user} \
        -d postgres \
        -c "REVOKE ALL ON pg_auth_members FROM public;"
    EOT
  }

  provisioner "local-exec" {
    command = <<-EOT
      PGPASSWORD="${var.postgres_password}" PGSSLMODE="${var.postgres_sslmode}" psql \
        -h ${var.postgres_host} \
        -p ${var.postgres_port} \
        -U ${var.postgres_user} \
        -d postgres \
        -c "REVOKE ALL ON pg_database FROM public;"
    EOT
  }

  provisioner "local-exec" {
    command = <<-EOT
      PGPASSWORD="${var.postgres_password}" PGSSLMODE="${var.postgres_sslmode}" psql \
        -h ${var.postgres_host} \
        -p ${var.postgres_port} \
        -U ${var.postgres_user} \
        -d postgres \
        -c "REVOKE ALL ON pg_tablespace FROM public;"
    EOT
  }

  provisioner "local-exec" {
    command = <<-EOT
      PGPASSWORD="${var.postgres_password}" PGSSLMODE="${var.postgres_sslmode}" psql \
        -h ${var.postgres_host} \
        -p ${var.postgres_port} \
        -U ${var.postgres_user} \
        -d postgres \
        -c "REVOKE ALL ON pg_settings FROM public;"
    EOT
  }
}