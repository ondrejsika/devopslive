add-kubeconfig:
	cp ~/.kube/config ~/.kube/config.$$(date +%Y%m%d%H%M%S).backup
	KUBECONFIG=kube_config_cluster.yml:~/.kube/config kubectl config view --raw > /tmp/kubeconfig.merge.yml && cp /tmp/kubeconfig.merge.yml ~/.kube/config
