DEPLOYMENT_NAME=seafile
HELM_REPO=local/seafile

install:
	helm install "$(DEPLOYMENT_NAME)" "$(HELM_REPO)" \
		-f helm-values.yaml -f helm-values.local.yaml

upgrade:
	helm upgrade "$(DEPLOYMENT_NAME)" "$(HELM_REPO)" \
		-f helm-values.yaml -f helm-values.local.yaml

helm_repo:
	@helm search local/

helm_test:
	helm test "$(DEPLOYMENT_NAME)"

