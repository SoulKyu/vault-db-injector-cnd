resource "vault_policy" "all_rw" {
  name = "all-rw"

  depends_on = [ vault_mount.kv_enablement ]

  policy = <<EOT
path "vault-injector/*" {
  capabilities = ["read", "list", "update", "create", "delete", "sudo"]
}

path "vault-injector/data/*" {
  capabilities = ["read", "list", "update", "create", "delete", "sudo"]
}

path "vault-injector/metadata/*" {
  capabilities = ["read", "list", "update", "create", "delete", "sudo"]
}

path "databases/creds/*" {
  capabilities = ["read"]
}

path "auth/kubernetes/role/*" {
  capabilities = ["read"]
}

path "sys/leases/renew" {
  capabilities = ["create"]
}

path "auth/token/renew-self" {
  capabilities = ["create"]
}

path "auth/token/renew" {
  capabilities = ["create", "update"]
}

path "auth/token/revoke" {
  capabilities = ["create", "update"]
}

path "auth/token/create" {
  capabilities = ["create", "update", "read"]
}

path "auth/token/create-orphan" {
  capabilities = ["create", "update", "read", "sudo"]
}

path "auth/token/revoke-orphan" {
  capabilities = ["create", "update", "sudo"]
}
EOT

}

resource "vault_policy" "app1_policy" {
  name = "app1"

  policy = <<EOT
path "databases/creds/app1" {
  capabilities = ["read"]
}
EOT

}