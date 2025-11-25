resource "vault_auth_backend" "kubernetes" {
  type        = "kubernetes"
  path        = "kubernetes"
  description = "Kubernetes authentication backend for pod authentication"
}

resource "vault_kubernetes_auth_backend_config" "kubernetes" {
  backend            = vault_auth_backend.kubernetes.path
  kubernetes_host    = "https://kubernetes.default.svc"
  disable_local_ca_jwt = false
}

resource "vault_kubernetes_auth_backend_role" "vault_db_injector" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "all-rw"
  bound_service_account_names      = ["vault-db-injector"]
  bound_service_account_namespaces = ["vault-db-injector"]
  token_ttl                        = 3600
  token_max_ttl                    = 3600
  token_policies                   = [vault_policy.all_rw.name]
  token_bound_cidrs                = ["10.42.0.0/16"]

}

resource "vault_kubernetes_auth_backend_role" "app1" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "app1"
  bound_service_account_names      = ["app1"]
  bound_service_account_namespaces = ["default"]
  token_ttl                        = 3600
  token_max_ttl                    = 3600
  token_policies                   = [vault_policy.app1_policy.name]
  token_bound_cidrs                = ["10.42.0.0/16"]

}