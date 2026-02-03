```bash
export VAULT_ADDR="http://127.0.0.1:8200"
export VAULT_TOKEN="root"
vault secrets enable database
vault write database/config/app1 \
  plugin_name=postgresql-database-plugin \
  allowed_roles="app1" \
  connection_url="postgresql://{{username}}:{{password}}@postgres-rw.postgres.svc.cluster.local:5432/postgres?sslmode=disable" \
  username="postgres" \
  password="postgres-password"
vault write database/roles/app1 \
  db_name=app1 \
  creation_statements="
    CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';
    GRANT CONNECT ON DATABASE app1 TO \"{{name}}\";
    GRANT USAGE ON SCHEMA public TO \"{{name}}\";
    GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO \"{{name}}\";
  " \
  default_ttl="1h" \
  max_ttl="24h"


vault read database/creds/app1
Key                Value
---                -----
lease_id           database/creds/example-role/2f6a614c-4aa2-7b19-24b9-ad944a8d4de6
lease_duration     1h
lease_renewable    true
password           FSREZ1S0kFsZtLat-y94
username           v-vaultuser-e2978cd0-ugp7iqI2hdlff5hfjylJ-1602537260
$ psql \
  -h 127.0.0.1 -p 55432 \
  -d app1 \
  -U 
  
```