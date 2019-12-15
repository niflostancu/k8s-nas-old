#!/bin/bash
# usage: create-user.sh secret-name username database
set -e

secretName="$1"
username="$2"
database="$3"
password=$(read -p "User's password: " -s pwd; echo -n "$pwd")

[[ -n "$secretName" && -n "$username" && -n "$database" ]] || {
	echo "Syntax: create-user.sh secret-name username database" >&2
	exit 1
}

SDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

kubectl create secret generic "$secretName" \
	--from-literal="mysql-user=$username" \
	--from-file="mysql-password="<(echo -n "$password")

echo "GRANT ALL PRIVILEGES ON $database.* TO '$username'@'%' IDENTIFIED BY '$password';" #| \
	"$SDIR"/client.sh

