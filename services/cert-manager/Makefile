DEPLOYMENT_NAME=cert-manager

install:
	helm install "$(DEPLOYMENT_NAME)" jetstack/cert-manager -f helm-values.yaml

upgrade:
	helm upgrade "$(DEPLOYMENT_NAME)" jetstack/cert-manager -f helm-values.yaml

helm_repo:
	helm repo add jetstack https://charts.jetstack.io

