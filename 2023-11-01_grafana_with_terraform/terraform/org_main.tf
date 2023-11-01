resource "grafana_organization" "main" {
  name         = "main"
  create_users = false
  admins       = []
  editors      = []
  viewers      = []
}
