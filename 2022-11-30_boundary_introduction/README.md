# Boundary Introduction

Install boundary on Mac

```
brew install hashicorp/tap/boundary
```

Run Boundary dev server

```
boundary dev
```

- Username: `admin`
- Password: `password`

Login in CLI

```
boundary authenticate password \
  -login-name=admin \
  -auth-method-id=ampw_1234567890
```

Open TCP tunnel (to 127.0.0.1)

```
boundary connect -target-id ttcp_1234567890
```

```
boundary connect -target-id ttcp_1234567890 -listen-port 50001
```

Test SSH

```
ssh 127.0.0.1 -p 50001
```

Connect using build in SSH

```
boundary connect -target-id ttcp_1234567890
```
