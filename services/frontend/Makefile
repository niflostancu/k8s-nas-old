DEPLOYMENT_NAME=frontend

install:
	helm install "$(DEPLOYMENT_NAME)" ingress-nginx/ingress-nginx \
		-f helm-values.yaml -f helm-values.local.yaml

upgrade:
	helm upgrade "$(DEPLOYMENT_NAME)" ingress-nginx/ingress-nginx \
		-f helm-values.yaml -f helm-values.local.yaml

helm_repo:
	helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

