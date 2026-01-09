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
K3D_FIX_DNS=0 k3d cluster create vault-db-test --servers 3 --agents 1 --image rancher/k3s:v1.34.3-k3s1
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
helm repo add openbao https://openbao.github.io/openbao-helm
helm repo update

helm upgrade --install openbao openbao/openbao \
  --namespace openbao \
  --create-namespace \
  --set='server.dev.enabled=true' \
  --set='ui.enabled=true' \
  --set='ui.serviceType=LoadBalancer' \
  --set='csi.agent.enabled=false' \
  --set='injector.enabled=false'
```

Verify the Vault Operator is running:

```bash
kubectl klock pods -n openbao
```

## Unseal Vault

```bash
kubectl logs openbao-0 -n openbao | grep 'Unseal Key:' | awk '{print $NF}' | xargs kubectl exec openbao-0 -n openbao -- vault operator unseal
```

## Step 4: Install PostgreSQL (CloudNativePG)

Install the CloudNativePG operator and create a PostgreSQL cluster:

```bash {"terminalRows":"11"}
helm upgrade --install cnpg cloudnative-pg \
  --repo https://cloudnative-pg.github.io/charts \
  --namespace cnpg-system \
  --create-namespace \
  --wait
kubectl apply -f ../demo/kubernetes/namespace.yaml
sleep 5
kubectl apply -f ../demo/kubernetes/cluster.yaml -f ../demo/kubernetes/secret.yaml
```

Verify PostgreSQL is running:

```bash
kubectl klock pods -n postgres
```

## Step 5: Configure Vault and Postgres

### Deploy postgres resources

```bash
kubectl port-forward -n postgres postgres-1 55432:5432 &
cd ../deploy/terraform/postgres
terraform init
terraform apply -auto-approve
exit

```

### Deploy vault terraform resources

```bash
kubectl port-forward -n openbao svc/openbao 8200:8200 &
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