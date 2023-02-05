terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
  }
  required_version = ">= 0.13"
}

variable "digitalocean_token" {}
provider "digitalocean" {
  token = var.digitalocean_token
}

variable "cloudflare_api_token" {}
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

module "script" {
  source    = "./modules/vm"
  suffix    = "script"
  user_data = <<EOF
#!/bin/bash
apt-get update
apt-get install -y nginx
echo "<h1>Hello from script</h1>" > /var/www/html/index.nginx-debian.html
EOF
}

module "simple" {
  source    = "./modules/vm"
  suffix    = "simple"
  user_data = <<EOF
#cloud-config

ssh_pwauth: yes
password: asdfasdf
package_upgrade: true
package_update: true
packages:
  - nginx
write_files:
  - path: /var/www/html/index.nginx-debian.html
    permissions: 0644
    owner: www-data
    content: |
      <h1>Hello from Cloud Config</h1>
EOF
}

module "cowsay" {
  source    = "./modules/vm"
  suffix    = "cowsay"
  user_data = <<EOF
#cloud-config

package_upgrade: true
package_update: true
packages:
  - nginx
  - cowsay
runcmd:
  - echo "<code><pre>" > /var/www/html/index.nginx-debian.html
  - /usr/games/cowsay Hello from Cloud Cow Say! >> /var/www/html/index.nginx-debian.html
  - echo "</pre></code>" >> /var/www/html/index.nginx-debian.html

EOF
}

module "advance" {
  source    = "./modules/vm"
  suffix    = "advance"
  user_data = <<EOF
#cloud-config

manage_resolv_conf: true

fqdn: advance.sikademo.com
hostname: advance

power_state:
  delay: "+1"
  mode: reboot
  message: Bye Bye
  timeout: 10
  condition: True
EOF
}

module "template" {
  source    = "./modules/vm"
  suffix    = "template"
  user_data = <<EOF
## template: jinja
#cloud-config
runcmd:
    - echo 'Hostname is {{ v1.availability_zone }}'
EOF
}
