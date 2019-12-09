DEPLOYMENT_NAME=cert-manager

VERSION=0.12

install:
	kubectl apply --validate=false \
		-f "https://raw.githubusercontent.com/jetstack/cert-manager/release-$(VERSION)/deploy/manifests/00-crds.yaml"
	helm install "$(DEPLOYMENT_NAME)" jetstack/cert-manager -f helm-values.yaml

upgrade:
	helm upgrade "$(DEPLOYMENT_NAME)" jetstack/cert-manager -f helm-values.yaml

helm_repo:
	helm repo add jetstack https://charts.jetstack.io



