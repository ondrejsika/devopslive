resource "digitalocean_droplet" "main" {
  image  = "ubuntu-20-10-x64"
  name   = "cloud-init-example-${var.suffix}"
  region = "fra1"
  size   = "s-2vcpu-2gb"
  ssh_keys = [
    local.ssh_key_id,
  ]
  user_data = var.user_data
}

resource "cloudflare_record" "main" {
  zone_id = local.zone_id

  name    = "cloud-init-${var.suffix}"
  value   = digitalocean_droplet.main.ipv4_address
  type    = "A"
  proxied = false
}
