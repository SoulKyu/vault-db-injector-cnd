# vault-db-injector Demo

**Cloud Native Days France 2026** | February 3rd, 2026

This repository contains everything you need to reproduce the demo from our Cloud Native Days France talk on dynamic database credential injection with Vault/OpenBao.

## What's this about?

Database credentials are a pain. You either hardcode them (please don't), rotate them manually (good luck), or build some elaborate pipeline that breaks at 3am. This project takes a different approach: let Kubernetes pods request fresh credentials automatically, and revoke them when the pod dies.

The vault-db-injector watches for pods with specific annotations, intercepts their creation, and injects short-lived database credentials before the container starts. When the pod terminates, credentials get revoked. No more stale passwords sitting around.

## Running the demo

The `docs/` folder contains step-by-step notebooks you can run directly in VSCode with the [Run in Terminal](https://marketplace.visualstudio.com/items?itemName=stateful.runme) extension. Each markdown file has executable code blocks - just click "Run" and watch it go.

No VSCode? Copy-paste the commands into your terminal. Works the same way.

### Order of operations

1. **[docs/initialize.md](docs/initialize.md)** - Sets up k3d cluster, OpenBao, PostgreSQL (CloudNativePG), and deploys vault-db-injector
2. **[docs/demo.md](docs/demo.md)** - Deploys a test app and shows credentials being injected
3. **[docs/demo-openbao.md](docs/demo-openbao.md)** - Manual walkthrough of Vault's database secrets engine (optional, for the curious)

## What you'll need

- Docker running locally
- `kubectl` and `helm` installed
- About 10 minutes

## How it works

Your pod declares what it wants through annotations:

```yaml
annotations:
  db-creds-injector.numberly.io/app1.role: app1
  db-creds-injector.numberly.io/app1.mode: uri
  db-creds-injector.numberly.io/app1.template: postgresql://@postgres-rw.postgres.svc.cluster.local:5432/app1
  db-creds-injector.numberly.io/app1.env-key-uri: POSTGRES_URL
labels:
  vault-db-injector: "true"
```

The injector sees this, fetches credentials from Vault, and injects a `POSTGRES_URL` environment variable with the full connection string. Your app just reads the env var. Done.

Three components handle the lifecycle:
- **Injector** - Mutating webhook that intercepts pod creation
- **Renewer** - Keeps credentials fresh before they expire
- **Revoker** - Cleans up when pods terminate

## Cleanup

```bash
k3d cluster delete vault-db-test
```

## Questions?

Open an issue or find us after the talk. We're happy to chat about the weird edge cases we hit building this.

---

*Demo presented at Cloud Native Days France, February 3rd, 2026*
