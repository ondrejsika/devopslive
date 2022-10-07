module "vm" {
  source  = "ondrejsika/ondrejsika-do-droplet/module"
  version = "1.2.0"

  for_each = {
    "ma0" = {}
    "ma1" = {}
    "ma2" = {}
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
runcmd:
  - |
    apt update
    apt install curl sudo git open-iscsi nfs-common
    curl -fsSL https://ins.oxs.cz/slu-linux-amd64.sh | sudo sh
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
    module.vm["ma0"].droplet.id,
    module.vm["ma1"].droplet.id,
    module.vm["ma2"].droplet.id,
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
    for vm in module.vm :
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
  name    = "*.${cloudflare_record.k8s.name}"
  value   = cloudflare_record.k8s.hostname
  type    = "CNAME"
  proxied = false
}
