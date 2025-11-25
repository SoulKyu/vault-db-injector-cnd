---
shell: /usr/bin/bash
---

# vault-db-injector demonstration

Complete demonstration of vault-db-injector usage

## deploy the app

```bash
kubectl apply -f ../demo/kubernetes/app1.yaml
kubectl klocks pods -n default
```

## validate the database access

```bash
kubectl exec -it app1 -- bash
# CREATE TABLE cars (brand VARCHAR(255), model VARCHAR(255), year INT);

# INSERT INTO cars (brand, model, year) VALUES ('Ford', 'Mustang', 1964);

# SELECT * FROM cars;
```
