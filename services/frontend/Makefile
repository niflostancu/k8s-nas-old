DEPLOYMENT_NAME=frontend

install:
	helm install "$(DEPLOYMENT_NAME)" nginx/nginx-ingress \
		-f helm-values.yaml -f helm-values.local.yaml

upgrade:
	helm upgrade "$(DEPLOYMENT_NAME)" nginx/nginx-ingress \
		-f helm-values.yaml -f helm-values.local.yaml

helm_repo:
	helm repo add nginx https://helm.nginx.com/stable

