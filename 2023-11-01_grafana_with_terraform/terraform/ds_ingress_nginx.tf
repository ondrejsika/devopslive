resource "grafana_data_source" "prometheus" {
  for_each = local.organizations

  org_id = each.value
  type   = "prometheus"
  name   = "ingress-nginx"
  uid    = "prometheus"
  url    = "https://prometheus-ingress-nginx-demo-data.sikademo.com"
}
