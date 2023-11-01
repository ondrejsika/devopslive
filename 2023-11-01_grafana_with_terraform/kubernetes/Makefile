install-grafana:
	helm upgrade --install \
      grafana grafana \
      --repo https://grafana.github.io/helm-charts \
      --version 6.60.1 \
      --create-namespace \
      --namespace grafana \
      --values ./grafana.values.yml \
      --wait

remove-grafana:
	helm uninstall grafana \
		--namespace grafana \
		--wait
