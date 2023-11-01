terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "2.4.0"
    }
  }
}

provider "grafana" {
  url  = "https://grafana.k8s.sikademo.com"
  auth = "admin:admin"
}
