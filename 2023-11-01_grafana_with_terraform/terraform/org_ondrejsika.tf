resource "grafana_organization" "ondrejsika" {
  name         = "ondrejsika"
  create_users = false
  admins       = []
  editors      = []
  viewers = [
    grafana_user.ondrej.email,
  ]
}

module "home_dashboard_ondrejsika" {
  source = "./modules/home_dashboard"
  name   = "Ondrej Sika"
}

resource "grafana_dashboard" "home_dashboard_ondrejsika" {
  org_id      = grafana_organization.ondrejsika.id
  config_json = module.home_dashboard_ondrejsika.json
}

resource "grafana_organization_preferences" "ondrejsika" {
  org_id             = grafana_organization.ondrejsika.id
  home_dashboard_uid = grafana_dashboard.home_dashboard_ondrejsika.uid
}
