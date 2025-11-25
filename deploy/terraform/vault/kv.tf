resource "vault_mount" "kv_enablement" {
  path        = "vault-injector"
  type        = "kv-v2"
  options = {
    version = "2"
    type    = "kv-v2"
  }
  description = "KV v2 secret engine for vault-db-injector state storage"
}