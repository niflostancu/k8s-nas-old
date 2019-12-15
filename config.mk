# Local configuration file (sample)
# Use 'config.local.mk' for overriding these variables.
#

# In case of multiple K8S clusters, please see
# https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/
KUBECONFIG=$(HOME)/.kube/kube-nas.yaml

-include "config.local.mk"

