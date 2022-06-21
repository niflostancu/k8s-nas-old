# Seafile deployment makefile
# WARNING: bugged / unmaintained, DO NOT USE (especially my alpine version which
# segfaults due to library issues)!

DEPLOYMENT_NAME=seafile
HELM_REPO=./local/seafile-0.2.tgz

install:
	helm install "$(DEPLOYMENT_NAME)" "$(HELM_REPO)" \
		-f helm-values.yaml -f helm-values.local.yaml

upgrade:
	helm upgrade "$(DEPLOYMENT_NAME)" "$(HELM_REPO)" \
		-f helm-values.yaml -f helm-values.local.yaml

volumes:
	kubectl apply -f volumes.local.yaml

helm_repo:
	@helm search local/

helm_test:
	helm test "$(DEPLOYMENT_NAME)"

