# Makefile for deploying the NAS services to the k8s cluster

include config.local.mk

deploy:
	rsync -avh --rsync-path="mkdir -p ~/k8s-nas/ && rsync" \
		./ "$(SERVER):k8s-nas"

get_kube_config:
	@echo "$(KUBECONFIG)"

.PHONY: get_kube_config
