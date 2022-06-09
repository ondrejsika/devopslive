resource "cloudflare_record" "main" {
  zone_id = local.sikademo_com_zone_id
  name    = "access"
  value   = "hello-world.sikademo.com"
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_access_application" "main" {
  zone_id                   = local.sikademo_com_zone_id
  name                      = cloudflare_record.main.name
  domain                    = cloudflare_record.main.hostname
  type                      = "self_hosted"
  auto_redirect_to_identity = false
}

resource "cloudflare_access_policy" "main" {
  zone_id        = local.sikademo_com_zone_id
  application_id = cloudflare_access_application.main.id
  name           = "Allow"
  precedence     = "1"
  decision       = "allow"

  include {
    email_domain = [
      "ondrejsika.com",
      "gmail.com",
    ]
  }
}

resource "cloudflare_access_application" "bypass" {
  zone_id                   = local.sikademo_com_zone_id
  name                      = cloudflare_record.main.name
  domain                    = "${cloudflare_record.main.hostname}/status"
  type                      = "self_hosted"
  auto_redirect_to_identity = false
}

resource "cloudflare_access_policy" "bypass" {
  zone_id        = local.sikademo_com_zone_id
  application_id = cloudflare_access_application.bypass.id
  name           = "Bypass"
  precedence     = "2"
  decision       = "bypass"

  include {
    everyone = true
  }
}

