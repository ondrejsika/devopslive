terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.8.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "2.20.0"
    }
  }
}

variable "digitalocean_token" {}

provider "digitalocean" {
  token = var.digitalocean_token
}

variable "cloudflare_api_token" {}
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

variable "cloudflare_zone_id" {
  # sikademo.com zone id
  default = "f2c00168a7ecd694bb1ba017b332c019"
}
variable "ssh_key_name" {
  default = "ondrejsika"
}

locals {
  user_data = <<EOF
#cloud-config

package_upgrade: true
package_update: true
runcmd:
  - add-apt-repository ppa:wireguard/wireguard
  - apt install -y wireguard
  - systemctl ufw stop
  - systemctl ufw disable
power_state:
  mode: reboot
  condition: True
EOF
}

data "digitalocean_ssh_key" "ondrejsika" {
  name = var.ssh_key_name
}

resource "digitalocean_droplet" "vpn" {
  image  = "ubuntu-20-04-x64"
  name   = "demo-vpn"
  region = "fra1"
  size   = "s-1vcpu-1gb"
  ssh_keys = [
    data.digitalocean_ssh_key.ondrejsika.id,
  ]
  user_data = local.user_data
}

resource "cloudflare_record" "vpn" {
  zone_id = var.cloudflare_zone_id
  name    = "vpn"
  value   = digitalocean_droplet.vpn.ipv4_address
  type    = "A"
  proxied = false
}

resource "digitalocean_droplet" "vmX" {
  count  = 4
  image  = "ubuntu-20-04-x64"
  name   = "demo-vm${count.index}"
  region = "fra1"
  size   = "s-1vcpu-1gb"
  ssh_keys = [
    data.digitalocean_ssh_key.ondrejsika.id,
  ]
  user_data = local.user_data
}

resource "cloudflare_record" "vmX" {
  count   = 4
  zone_id = var.cloudflare_zone_id
  name    = "vm${count.index}"
  value   = digitalocean_droplet.vmX[count.index].ipv4_address
  type    = "A"
  proxied = false
}
