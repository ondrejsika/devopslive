terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

variable "cloudflare_api_token" {}
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

locals {
  account_id           = "8a5e13ad9edd5be4595027085cf61ce7"
  sikademo_com_zone_id = "f2c00168a7ecd694bb1ba017b332c019"
}

resource "random_string" "secret" {
  length  = 32
  special = false
}

module "tunnel--local" {
  source        = "./modules/tunnel"
  account_id    = local.account_id
  zone_id       = local.sikademo_com_zone_id
  secret_base64 = base64encode(random_string.secret.result)
  tunnel_name   = "local"
  record_name   = "tunnel-local"
}

module "tunnel--red" {
  source        = "./modules/tunnel"
  account_id    = local.account_id
  zone_id       = local.sikademo_com_zone_id
  secret_base64 = base64encode(random_string.secret.result)
  tunnel_name   = "red"
  record_name   = "tunnel-red"
}

module "tunnel--green" {
  source        = "./modules/tunnel"
  account_id    = local.account_id
  zone_id       = local.sikademo_com_zone_id
  secret_base64 = base64encode(random_string.secret.result)
  tunnel_name   = "green"
  record_name   = "tunnel-green"
}

module "tunnel--blue" {
  source        = "./modules/tunnel"
  account_id    = local.account_id
  zone_id       = local.sikademo_com_zone_id
  secret_base64 = base64encode(random_string.secret.result)
  tunnel_name   = "blue"
  record_name   = "tunnel-blue"
}

output "local" {
  value     = module.tunnel--local.tunnel_config
  sensitive = true
}

output "red" {
  value     = module.tunnel--red.tunnel_config
  sensitive = true
}

output "green" {
  value     = module.tunnel--green.tunnel_config
  sensitive = true
}

output "blue" {
  value     = module.tunnel--blue.tunnel_config
  sensitive = true
}
