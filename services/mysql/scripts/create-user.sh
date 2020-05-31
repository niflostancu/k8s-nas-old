#!/bin/bash
# usage: create-user.sh secret-name username database
set -e

secretName="$1"
username="$2"
database="$3"

[[ -n "$secretName" && -n "$username" && -n "$database" ]] || {
	echo "Syntax: create-user.sh secret-name username database" >&2
	exit 1
}

SDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if kubectl get secret "$secretName" >/dev/null 2>&1; then
	password=$(kubectl get secret "$secretName" --template="{{ index .data \"mysql-password\" }}" | base64 --decode)
else
	password=$(read -p "User's password: " -s pwd; echo -n "$pwd")
	kubectl create secret generic "$secretName" \
		--from-literal="mysql-user=$username" \
		--from-file="mysql-password="<(echo -n "$password")
fi

QUERY="CREATE USER '$username'@'%' IDENTIFIED BY '$password';
GRANT ALL PRIVILEGES ON $database.* TO '$username'@'%';"
if [[ -n "$SHOW_QUERY" ]]; then
	echo "$QUERY"
else
	echo "$QUERY" | "$SDIR"/client.sh
fi

