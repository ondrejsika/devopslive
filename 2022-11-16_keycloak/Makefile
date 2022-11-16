install-keycloak:
	kubectl apply -f keycloak-ns.yml
	kubectl apply -f keycloak.yml -n keycloak

install-oauth2-proxy:
	helm upgrade --install \
		oauth2-proxy \
		oauth2-proxy --repo https://oauth2-proxy.github.io/manifests \
		--namespace oauth2-proxy \
		--create-namespace \
		--values oauth2-proxy.values.yml

install-example:
	kubectl apply -f example.yml
