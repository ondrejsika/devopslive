variable "digitalocean_token" {}
provider "digitalocean" {
  token = var.digitalocean_token
}

variable "cloudflare_email" {}
variable "cloudflare_token" {}
provider "cloudflare" {
  version = "~> 1.0"
  email   = var.cloudflare_email
  token   = var.cloudflare_token
}
