resource "random_password" "rke2-token" {
  length  = 32
  special = false
}

module "ma0" {
  source  = "ondrejsika/ondrejsika-do-droplet/module"
  version = "1.2.0"

  size  = "s-2vcpu-4gb"
  image = "debian-11-x64"
  tf_ssh_keys = [
    data.digitalocean_ssh_key.ondrejsika.id
  ]
  zone_id      = local.sikademo_com_zone_id
  droplet_name = "ma0"
  record_name  = "ma0"
  user_data    = <<EOF
#cloud-config
ssh_pwauth: yes
password: asdfasdf2020
chpasswd:
  expire: false
write_files:
- path: /etc/rancher/rke2/config.yaml
  permissions: "0600"
  owner: root:root
  content: |
    tls-san: 
      - k8s-api.sikademo.com
      - ma0.sikademo.com
      - ma1.sikademo.com
      - ma2.sikademo.com
    token: ${random_password.rke2-token.result}
    node-taint:
      - "CriticalAddonsOnly=true:NoExecute"
    disable:
      - rke2-ingress-nginx
runcmd:
  - |
    apt update
    apt install -y curl sudo git
    curl -fsSL https://ins.oxs.cz/slu-linux-amd64.sh | sudo sh
    curl -sfL https://get.rke2.io | INSTALL_RKE2_METHOD='tar' sh -
    systemctl enable rke2-server.service
    systemctl start rke2-server.service
EOF
}

module "ma" {
  source  = "ondrejsika/ondrejsika-do-droplet/module"
  version = "1.2.0"

  for_each = {
    "ma1" = {}
    "ma2" = {}
  }

  size  = "s-2vcpu-4gb"
  image = "debian-11-x64"
  tf_ssh_keys = [
    data.digitalocean_ssh_key.ondrejsika.id
  ]
  zone_id      = local.sikademo_com_zone_id
  droplet_name = each.key
  record_name  = each.key
  user_data    = <<EOF
#cloud-config
ssh_pwauth: yes
password: asdfasdf2020
chpasswd:
  expire: false
write_files:
- path: /etc/rancher/rke2/config.yaml
  permissions: "0600"
  owner: root:root
  content: |
    server: https://${module.ma0.droplet.ipv4_address}:9345
    tls-san: 
      - k8s-api.sikademo.com
      - ma0.sikademo.com
      - ma1.sikademo.com
      - ma2.sikademo.com
    token: ${random_password.rke2-token.result}
    node-taint:
      - "CriticalAddonsOnly=true:NoExecute"
    disable:
      - rke2-ingress-nginx
runcmd:
  - |
    apt update
    apt install -y curl sudo git
    curl -fsSL https://ins.oxs.cz/slu-linux-amd64.sh | sudo sh
    curl -sfL https://get.rke2.io | INSTALL_RKE2_METHOD='tar' sh -
    systemctl enable rke2-server.service
    slu wf tcp -a ${module.ma0.droplet.ipv4_address}:9345
    systemctl start rke2-server.service
EOF
}

module "wo" {
  source  = "ondrejsika/ondrejsika-do-droplet/module"
  version = "1.2.0"

  for_each = {
    "wo0" = {}
    "wo1" = {}
  }

  size  = "s-2vcpu-4gb"
  image = "debian-11-x64"
  tf_ssh_keys = [
    data.digitalocean_ssh_key.ondrejsika.id
  ]
  zone_id      = local.sikademo_com_zone_id
  droplet_name = each.key
  record_name  = each.key
  user_data    = <<EOF
#cloud-config
ssh_pwauth: yes
password: asdfasdf2020
chpasswd:
  expire: false
write_files:
- path: /etc/rancher/rke2/config.yaml
  permissions: "0600"
  owner: root:root
  content: |
    server: https://${module.ma0.droplet.ipv4_address}:9345
    token: ${random_password.rke2-token.result}
runcmd:
  - |
    apt update
    apt install -y curl sudo git
    curl -fsSL https://ins.oxs.cz/slu-linux-amd64.sh | sudo sh
    curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE="agent" INSTALL_RKE2_METHOD='tar' sh -
    systemctl enable rke2-agent.service
    slu wf tcp -a ${module.ma0.droplet.ipv4_address}:9345
    systemctl start rke2-agent.service
EOF
}

resource "digitalocean_loadbalancer" "k8s-api" {
  name   = "rke2-k8s-api"
  region = "fra1"

  forwarding_rule {
    entry_port     = 6443
    entry_protocol = "tcp"

    target_port     = 6443
    target_protocol = "tcp"
  }

  forwarding_rule {
    entry_port     = 9345
    entry_protocol = "tcp"

    target_port     = 9345
    target_protocol = "tcp"
  }

  healthcheck {
    port     = 6443
    protocol = "tcp"
  }

  droplet_ids = [
    module.ma0.droplet.id,
    module.ma["ma1"].droplet.id,
    module.ma["ma2"].droplet.id,
  ]
}

resource "cloudflare_record" "k8s-api" {
  zone_id = local.sikademo_com_zone_id
  name    = "k8s-api"
  value   = digitalocean_loadbalancer.k8s-api.ip
  type    = "A"
  proxied = false
}

resource "digitalocean_loadbalancer" "k8s" {
  name   = "rke2-k8s"
  region = "fra1"


  forwarding_rule {
    entry_port     = 80
    entry_protocol = "tcp"

    target_port     = 80
    target_protocol = "tcp"
  }

  forwarding_rule {
    entry_port     = 443
    entry_protocol = "tcp"

    target_port     = 443
    target_protocol = "tcp"
  }

  healthcheck {
    port     = 80
    protocol = "tcp"
  }

  droplet_ids = [
    for vm in module.wo :
    vm.droplet.id
  ]
}

resource "cloudflare_record" "k8s" {
  zone_id = local.sikademo_com_zone_id
  name    = "k8s"
  value   = digitalocean_loadbalancer.k8s.ip
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "k8s-wildcard" {
  zone_id = local.sikademo_com_zone_id
  name    = "*.k8s"
  value   = cloudflare_record.k8s.hostname
  type    = "CNAME"
  proxied = false
}
