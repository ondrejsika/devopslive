resource "grafana_dashboard" "ingress_nginx_1" {
  for_each = local.organizations

  org_id      = each.value
  config_json = file("dashboards/ingress_nginx_1.json")
}
