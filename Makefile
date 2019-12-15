# Makefile for deploying the NAS services to the k8s cluster

include config.local.mk

get_kube_config:
	@echo "$(KUBECONFIG)"

.PHONY: get_kube_config
