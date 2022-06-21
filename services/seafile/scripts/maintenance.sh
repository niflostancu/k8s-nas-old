#!/bin/bash
# Utility script for seafile server maintenance
# Brings the deployment down and puts you into a shell.

set -e

TEMPLATE=$(kubectl get deployment/seafile -o=jsonpath='{ .spec.template.spec }' | jq)
OVERRIDES='{
  "containers": [{
    "name": "seafile-maintenance",
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

kubectl run seafile-maintenance ${KUBECTL_ARGS} --restart=Never \
  --overrides="$CONTAINER_SPEC" --image="${IMAGE}"

