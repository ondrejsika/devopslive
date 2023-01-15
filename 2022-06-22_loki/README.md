# Loki

![loki](./img/loki1.jpg)
![loki](./img/loki2.jpg)

[@wild.loki.appears](https://www.instagram.com/wild.loki.appears/)

[@loki](https://www.instagram.com/loki/)


```
helm repo add grafana https://grafana.github.io/helm-charts
```

```
helm upgrade --install loki grafana/loki \
  --namespace loki \
  --create-namespace \
  --values loki.values.yml
```

```
helm upgrade --install grafana grafana/grafana \
  --namespace grafana \
  --create-namespace \
  --values grafana.values.yml
```

```
helm upgrade --install promtail grafana/promtail \
  --namespace promtail \
  --create-namespace \
  --values promtail.values.yml
```

```
kubectl apply -f loggen.yml -f loggen-fast.yml -f loggen-slow.yml
```

```
{app="loggen"}
```

```
{app=~"loggen.*"} | line_format "{{ .app }}"
```

```
{app=~"loggen.*"} |= "ERROR"
```

```
{app=~"loggen.*"} != "DEBUG"
```

```
{app=~"loggen.*"} != "DEBUG" != "INFO"
```

```
{app=~"loggen.*"} | pattern `<_> <_> <_> <level> <msg> (i=<i>)` | line_format "{{ .i }} -- {{ .app }} -- {{.level}} -- {{.msg}}"
```

```
kubectl port-forward -n loki svc/loki-read 3100:3100
```

```
export LOKI_ADDR=http://127.0.0.1:3100
```

```
logcli query '{app="loggen-slow"} | pattern `<_> <_> <_> <level> <msg> (i=<i>)` | line_format "{{ .i }} -- {{ .app }} -- {{.level}} -- {{.msg}}"'
```
