DEPLOYMENT_NAME=syncthing
HELM_REPO=k8s-at-home/syncthing

install:
	helm install "$(DEPLOYMENT_NAME)" "$(HELM_REPO)" \
		-f helm-values.yaml -f helm-values.local.yaml

upgrade:
	helm upgrade "$(DEPLOYMENT_NAME)" "$(HELM_REPO)" \
		-f helm-values.yaml -f helm-values.local.yaml

helm_repo:
	helm repo add k8s-at-home https://k8s-at-home.com/charts/
	helm repo update

helm_test:
	helm test "$(DEPLOYMENT_NAME)"

forward:
	export POD_NAME=$$(kubectl get pods --namespace default \
		-l "app.kubernetes.io/name=syncthing,app.kubernetes.io/instance=syncthing" \
		-o jsonpath="{.items[0].metadata.name}"); \
	echo "Visit http://127.0.0.1:8080 to use your application" && \
	kubectl port-forward $$POD_NAME 8080:8384

