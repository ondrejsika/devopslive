terraform {
  required_providers {
    keycloak = {
      source  = "mrparkers/keycloak"
      version = "4.0.1"
    }
  }
}

provider "keycloak" {
  client_id = "admin-cli"
  username  = "admin"
  password  = "admin"
  url       = "https://sso.k8s.sikademo.com"
}

resource "keycloak_realm" "example" {
  realm                    = "example"
  enabled                  = true
  display_name_html        = "<h1>Example Realm</h1>"
  login_with_email_allowed = true
}

resource "keycloak_user" "foo" {
  realm_id       = keycloak_realm.example.id
  username       = "foo"
  enabled        = true
  email          = "foo@sikademo.com"
  email_verified = true
  initial_password {
    value = "asdf"
  }
}

resource "keycloak_user" "bar" {
  realm_id       = keycloak_realm.example.id
  username       = "bar"
  enabled        = true
  email          = "bar@sikademo.com"
  email_verified = true
  initial_password {
    value = "asdf"
  }
}

resource "keycloak_openid_client" "oauth2-proxy" {
  realm_id              = keycloak_realm.example.id
  client_id             = "oauth2-proxy"
  enabled               = true
  access_type           = "CONFIDENTIAL"
  standard_flow_enabled = true
  valid_redirect_uris = [
    "https://oauth.k8s.sikademo.com/oauth2/callback"
  ]
  root_url      = "$${authBaseUrl}"
  admin_url     = "$${authBaseUrl}"
  web_origins   = ["+"]
  client_secret = "jlfa14HlYOmqeAdXZyfMSWl50Fd96pkf"
}

