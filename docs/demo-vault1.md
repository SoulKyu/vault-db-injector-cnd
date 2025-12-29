---
shell: /usr/bin/bash
---

# Vault Database Secrets Engine - Proof of Concept

Demonstration of how Vault's database secrets engine generates dynamic credentials for PostgreSQL.

## Prerequisites

Ensure port-forwards are active:

```bash {"background":"true","name":"port-forwards"}
kubectl port-forward -n vault svc/vault 8200:8200 &
kubectl port-forward -n postgres svc/postgres-postgresql 55432:5432 &
```

## Setup Environment

## Generate Database Credentials

Request dynamic credentials from Vault's database secrets engine:

```bash {"name":"get-creds","promptEnv":"false"}
CREDS=$(VAULT_TOKEN=root VAULT_ADDR=http://127.0.0.1:8200 vault read -format=json databases/creds/app1)
echo "$CREDS" | jq

export PGUSER=$(echo $CREDS | jq -r '.data.username')
export PGPASSWORD=$(echo $CREDS | jq -r '.data.password')
export LEASE_ID=$(echo $CREDS | jq -r '.lease_id')
```

## Connect to PostgreSQL

Use the generated credentials to connect and verify:

```bash {"promptEnv":"false"}
psql -h 127.0.0.1 -p 55432 -d app1 -c "SELECT current_user;" -c "SELECT current_database();"
```

## Lease Information

View the lease details for the generated credentials:

```bash {"promptEnv":"false"}
VAULT_TOKEN=root VAULT_ADDR=http://127.0.0.1:8200 vault list sys/leases/lookup/databases/creds/app1

VAULT_TOKEN=root VAULT_ADDR=http://127.0.0.1:8200 vault lease lookup $LEASE_ID
```
