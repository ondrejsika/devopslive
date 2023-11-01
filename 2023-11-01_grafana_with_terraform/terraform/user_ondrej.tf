resource "grafana_user" "ondrej" {
  email    = "ondrej@sikademo.com"
  name     = "Ondrej Sika"
  login    = "ondrej"
  password = "asdfasdf"
  is_admin = false
}
