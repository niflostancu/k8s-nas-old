#!/bin/bash
set -e

scr=
scr+="(printf '[client]\\npassword='; cat /etc/mysql/.secrets/mysql-root-password; ) > ~/.my.cnf; "
scr+='mysql -h mysql'

json_escape() {
  printf '%s' "$1" | \
    python3 -c 'import json, sys; print(json.dumps(sys.stdin.read()))'
}

args="-i --tty --rm"
#args="--dry-run -o yaml"

kubectl run mysql-client $args --generator=run-pod/v1 --restart=Never --overrides='
{"spec": {
  "containers": [{
    "name": "mysql-client",
    "image": "mysql",
    "command": ["bash"],
    "args": ["-c", '"$(json_escape "$scr")"'],
    "stdin": true, "tty": true,
    "volumeMounts": [{
      "name": "mysql-secrets",
      "mountPath": "/etc/mysql/.secrets",
      "readOnly": true
    }]
  }],
  "volumes": [{
    "name": "mysql-secrets",
    "secret": {"secretName": "mysql"}
  }]
} }
' --image=mysql

