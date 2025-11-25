---
shell: /usr/bin/bash
---

# vault-db-injector Local Testing Environment Setup

Complete guide to set up a local Kubernetes cluster with Vault, PostgreSQL, and vault-db-injector using k3d.

## Prerequisites

- Docker installed and running
- `kubectl` installed locally
- `helm` installed locally

## Step 1: Install k3d

Install k3d using the official installation script:

```bash
wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
```

Verify installation:

```bash
k3d --version
```

## Step 2: Create k3d Cluster

Create a new k3d cluster named `vault-db-test`:

```bash
K3D_FIX_DNS=0 k3d cluster create vault-db-test --servers 3 --agents 1 --image rancher/k3s:v1.34.1-k3s1
```

Verify the cluster is running:

```bash
kubectl cluster-info --context k3d-vault-db-test
kubectl get nodes --context k3d-vault-db-test
```

## Step 3: Install Vault

Install the Vault instance :

```bash
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update

helm upgrade --install vault hashicorp/vault \
  --namespace vault \
  --create-namespace \
  --set='server.dev.enabled=true' \
  --set='ui.enabled=true' \
  --set='ui.serviceType=LoadBalancer' \
  --set='csi.agent.enabled=false' \
  --set='injector.enabled=false'
```

Verify the Vault Operator is running:

```bash
kubectl klock pods -n vault
```

## Unseal Vault

```bash
kubectl logs vault-0 -n vault | grep 'Unseal Key:' | awk '{print $NF}' | xargs kubectl exec vault-0 -n vault -- vault operator unseal
```

## Step 4: Install PostgreSQL

Create the `postgres` namespace and install PostgreSQL:

```bash {"terminalRows":"11"}
helm upgrade --install postgres oci://registry-1.docker.io/bitnamicharts/postgresql \
  --create-namespace \
  --namespace postgres \
  --set auth.password=postgres-password \
  --set primary.persistence.enabled=false \
  --set replica.persistence.enabled=false
```

Verify PostgreSQL is running:

```bash
kubectl klock pods -n postgres
```

## Step 5: Configure Vault and Postgres

### Deploy postgres resources

```bash
kubectl port-forward -n postgres svc/postgres-postgresql 55432:5432 &
cd ../deploy/terraform/postgres
terraform init
terraform apply -auto-approve
exit

```

### Deploy vault terraform resources

```bash
kubectl port-forward -n vault svc/vault 8200:8200 &
cd ../deploy/terraform/vault
terraform init
terraform apply -auto-approve
exit
```

## Step 5: Deploy vault-db-injector

Create the `vault-db-injector` namespace and deploy the application:

```bash
kubectl create namespace vault-db-injector
```

Install vault-db-injector:

```bash
helm upgrade --install \
  cert-manager oci://quay.io/jetstack/charts/cert-manager \
  --version v1.19.1 \
  --namespace cert-manager \
  --create-namespace \
  --set crds.enabled=true

helm upgrade --install --create-namespace vault-db-injector ../deploy/kubernetes/vault-db-injector/helm \
  --namespace vault-db-injector
```

Verify deployment:

```bash
kubectl get pods -n vault-db-injector
kubectl get leases -n vault-db-injector
```

## Cleanup

To destroy the entire cluster and free up resources:

```bash
k3d cluster delete vault-db-test
```