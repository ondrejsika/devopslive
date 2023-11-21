# Sealed Secrets

## Install Controller

<https://github.com/bitnami-labs/sealed-secrets#controller>

```bash
helm upgrade --install \
  sealed-secrets \
  sealed-secrets \
  --repo https://bitnami-labs.github.io/sealed-secrets \
  -n kube-system \
  --set-string fullnameOverride=sealed-secrets-controller
```

## Install `kubeseal`

<https://github.com/bitnami-labs/sealed-secrets#kubeseal>

```bash
brew install kubeseal
```

## Create Local Secrets

```bash
echo -n bar | kubectl create secret generic example-secret-1 --dry-run=client --from-file=foo=/dev/stdin -o yaml > example-secret-1.local.yml
```

or use existing secret

```bash
cat example-secret-2.yml
```

## Encrypt Secrets

```bash
kubeseal -f example-secret-1.local.yml -w example-sealedsecret-1.yml
```

```bash
kubeseal -f example-secret-2.yml -w example-sealedsecret-2.yml
```

## Apply Secrets

```bash
kubectl apply -f example-sealedsecret-1.yml
```

```bash
kubectl apply -f example-sealedsecret-2.yml
```

## Profit

```bash
kubectl get secret example-secret-1 -o go-template='{{index .data "foo" |  base64decode}}{{"\n"}}'
```

```bash
kubectl get secret example-secret-2 -o go-template='{{index .data "hello" |  base64decode}}{{"\n"}}'
```
