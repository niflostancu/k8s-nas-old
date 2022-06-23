#!/bin/bash
# Custom container entrypoint which modifies the UID / GID for the nextcloud/webserver user

if [ -z "$WWW_UID" ]; then
	WWW_UID=1000
fi
if [ -z "$WWW_GID" ]; then
	WWW_GID=1000
fi

usermod -u "$WWW_UID" www-data
groupmod -g "$WWW_GID" www-data

exec "/entrypoint.sh" "$@"

