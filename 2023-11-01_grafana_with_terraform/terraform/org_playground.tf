resource "grafana_organization" "playground" {
  name         = "playground"
  create_users = false
  admins = [
    grafana_user.ondrej.email,
  ]
  editors = []
  viewers = []
}

module "home_dashboard_playground" {
  source = "./modules/home_dashboard"
  name   = "Playground"
}

resource "grafana_dashboard" "home_dashboard_playground" {
  org_id      = grafana_organization.playground.id
  config_json = module.home_dashboard_playground.json
}

resource "grafana_organization_preferences" "playground" {
  org_id             = grafana_organization.playground.id
  home_dashboard_uid = grafana_dashboard.home_dashboard_playground.uid
}
