# Keycloak

Install Keycloak

```
make install-keycloak
```

See: <https://sso.k8s.sikademo.com/admin/master/console/#/master>


Apply Keycloak configuration

```
terraform init
```

```
terraform apply
```

Install Oauth2 Proxy

```
make install-oauth2-proxy
```

Deploy example app

```
make install-example
```

See: <https://example.k8s.sikademo.com>
