variable "ssh_key" {}
variable "cluster_no" {}
variable "node_count" {}

resource "digitalocean_droplet" "nodes" {
  count = var.node_count

  image  = "docker-18-04"
  name   = "rke${var.cluster_no}no${count.index}"
  region = "fra1"
  size   = "s-4vcpu-8gb"
  ssh_keys = [
    var.ssh_key.id
  ]
  tags = [
    "rke${var.cluster_no}",
  ]
  user_data = <<-EOT
    #!/bin/sh
    ufw disable
  EOT
}

resource "cloudflare_record" "nodes" {
  count = var.node_count

  domain  = "sikademo.com"
  name    = "rke${var.cluster_no}no${count.index}"
  value   = digitalocean_droplet.nodes[count.index].ipv4_address
  type    = "A"
  proxied = false
}

resource "digitalocean_loadbalancer" "lb" {
  name   = "rke${var.cluster_no}"
  region = "fra1"

  droplet_tag = "rke${var.cluster_no}"

  healthcheck {
    port     = 30001
    protocol = "tcp"
  }

  forwarding_rule {
    entry_port      = 80
    target_port     = 30001
    entry_protocol  = "tcp"
    target_protocol = "tcp"
  }

  forwarding_rule {
    entry_port      = 443
    target_port     = 30002
    entry_protocol  = "tcp"
    target_protocol = "tcp"
  }

  forwarding_rule {
    entry_port      = 8080
    target_port     = 30003
    entry_protocol  = "tcp"
    target_protocol = "tcp"
  }
}


resource "cloudflare_record" "lb" {
  domain  = "sikademo.com"
  name    = "rke${var.cluster_no}"
  value   = digitalocean_loadbalancer.lb.ip
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "main_wildcard" {
  domain  = "sikademo.com"
  name    = "*.${cloudflare_record.lb.name}"
  value   = cloudflare_record.lb.hostname
  type    = "CNAME"
  proxied = false
}
