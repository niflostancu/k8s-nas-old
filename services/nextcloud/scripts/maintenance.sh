#!/bin/bash
# Utility script for a Nextcloud maintenance shell

set -e

TEMPLATE=$(kubectl get deployment/nextcloud -o=jsonpath='{ .spec.template.spec }' | jq)
OVERRIDES='{
  "containers": [{
    "name": "nextcloud-maintenance",
    "securityContext": {
      "runAsUser": 1000,
      "runAsGroup": 1000
    },
    "command": ["bash"],
    "stdin": true, "tty": true,
    "livenessProbe": null,
    "readinessProbe": null
  }],
  "restartPolicy": "Never"
}'
CONTAINER_SPEC=$(echo "$TEMPLATE $OVERRIDES" | jq -s '{
  spec: (
    .[0] as $t | .[1] as $o | $t + $o |
    .containers=[($t.containers[0] + $o.containers[0])]
  )
}')

IMAGE=$(echo "$CONTAINER_SPEC" | jq '.spec.containers[0].image' | cut -d '"' -f 2)
#echo "$CONTAINER_SPEC"

KUBECTL_ARGS="-i --tty --rm"
#KUBECTL_ARGS="--dry-run -o yaml"

kubectl run nextcloud-maintenance ${KUBECTL_ARGS} --restart=Never \
  --overrides="$CONTAINER_SPEC" --image="${IMAGE}"

