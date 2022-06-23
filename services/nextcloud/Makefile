DEPLOYMENT_NAME=nextcloud
HELM_REPO=nextcloud/nextcloud

DOCKER_IMAGE = niflostancu/nextcloud-uid:latest

install: build_image push_image
	helm install "$(DEPLOYMENT_NAME)" "$(HELM_REPO)" \
		-f helm-values.yaml -f helm-values.local.yaml

upgrade: build_image push_image
	helm upgrade "$(DEPLOYMENT_NAME)" "$(HELM_REPO)" \
		-f helm-values.yaml -f helm-values.local.yaml

volumes:
	kubectl apply -f volumes.local.yaml

helm_repo:
	helm repo add nextcloud https://nextcloud.github.io/helm/

helm_test:
	helm test "$(DEPLOYMENT_NAME)"

build_image:
	docker build -t "$(DOCKER_IMAGE)" custom-image/

push_image:
	docker push "$(DOCKER_IMAGE)"

