# RKE2

## First Master

```
curl -sfL https://get.rke2.io | sh -
mkdir -p /etc/rancher/rke2/
cat << EOF > /etc/rancher/rke2/config.yaml
token: supersecuretoken
tls-san: k8s-api.sikademo.com
node-taint:
    - "CriticalAddonsOnly=true:NoExecute"
EOF
systemctl enable rke2-server.service
systemctl start rke2-server.service
```

Validate

```
/var/lib/rancher/rke2/bin/kubectl --kubeconfig /etc/rancher/rke2/rke2.yaml get nodes
```

Or

```
export PATH="$PATH":/var/lib/rancher/rke2/bin && export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
```

```
kubectl get nodes
```

## Other Masters

```
curl -sfL https://get.rke2.io | sh -
mkdir -p /etc/rancher/rke2/
cat << EOF > /etc/rancher/rke2/config.yaml
server: https://k8s-api.sikademo.com:9345
token: supersecuretoken
tls-san:
    - k8s-api.sikademo.com
    - ma0.sikademo.com
    - ma1.sikademo.com
    - ma2.sikademo.com
node-taint:
    - "CriticalAddonsOnly=true:NoExecute"
EOF
systemctl enable rke2-server.service
systemctl start rke2-server.service
```

## Workers

```
curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE="agent" sh -
mkdir -p /etc/rancher/rke2/
cat << EOF > /etc/rancher/rke2/config.yaml
server: https://k8s-api.sikademo.com:9345
token: supersecuretoken
EOF
systemctl enable rke2-agent.service
systemctl start rke2-agent.service
```
