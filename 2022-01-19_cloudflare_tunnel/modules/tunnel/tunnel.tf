terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

variable "account_id" {}
variable "zone_id" {}
variable "secret_base64" {}
variable "tunnel_name" {}
variable "record_name" {}


resource "cloudflare_argo_tunnel" "main" {
  account_id = var.account_id
  name       = var.tunnel_name
  secret     = var.secret_base64
}

resource "cloudflare_record" "main" {
  zone_id = var.zone_id
  name    = var.record_name
  value   = cloudflare_argo_tunnel.main.cname
  type    = "CNAME"
  proxied = true
}

output "tunnel_config" {
  value = {
    AccountTag   = var.account_id
    TunnelSecret = cloudflare_argo_tunnel.main.secret
    TunnelID     = cloudflare_argo_tunnel.main.id
  }
  sensitive = true
}
