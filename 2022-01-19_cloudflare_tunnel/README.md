# DevOps Live #28: Cloudflare Argo Tunnel

## Setup Tunnels using Terraform

```
terraform init
terraform apply
```

## Local

## Install `cloudflared`

```
brew install cloudflare/tap/cloudflared
```

## Authenticate

```
cloudflared login
```

## Run Hello World Server

```
slu install-bin -n hello-world-server -u https://github.com/sikalabs/hello-world-server/releases/download/v0.4.0/hello-world-server_v0.4.0_linux_amd64.tar.gz
hello-world-server
```

## Get Tunnel Config

```
terraform output --json local
```

## Run `cloudflared`

```
TUNNEL_CRED_CONTENTS='{"AccountTag":"...","TunnelID":"...","TunnelSecret":"..."}'
TUNNEL_ID=...
cloudflared tunnel run --credentials-contents $TUNNEL_CRED_CONTENTS --url http://127.0.0.1:8000 $TUNNEL_ID
```

## Kubernetes

## Setup HELM

```
helm repo add sikalabs https://helm.sikalabs.io
helm repo update
```

## Run Minikube

```
minikube start
minikube addons enable ingress
```

## Run `minikube tunnel`

```
minikube tunnel
```

## Install Example Apps

```
helm upgrade --install red sikalabs/hello-world \
    --set image=sikalabs/hello-world-server:red \
    --set host=red.127.0.0.1.nip.io
helm upgrade --install green sikalabs/hello-world \
    --set image=sikalabs/hello-world-server:green \
    --set host=green.127.0.0.1.nip.io
helm upgrade --install blue sikalabs/hello-world \
    --set image=sikalabs/hello-world-server:blue \
    --set host=blue.127.0.0.1.nip.io
```

## Create `values/secrets.yml`

```
cp ./values/secrets.EXAMPLES.yml ./values/secrets.yml
vim ./values/secrets.yml
```

## Install Tunnels

```
helm upgrade --install red-tunnel sikalabs/cloudflare-tunnel \
    -f ./values/global.yml \
    -f ./values/secrets.yml \
    -f ./values/red.yml
helm upgrade --install gree-tunnel sikalabs/cloudflare-tunnel \
    -f ./values/global.yml \
    -f ./values/secrets.yml \
    -f ./values/green.yml
helm upgrade --install blue-tunnel sikalabs/cloudflare-tunnel \
    -f ./values/global.yml \
    -f ./values/secrets.yml \
    -f ./values/blue.yml
```
