#!/bin/bash
# Creates a k8s secret from prompt

NAME="$1"
FILENAME="$2"

kubectl create secret generic "$NAME" --namespace default \
	--from-file="$FILENAME"=<(read -s -p "Enter your secret: " p; echo -n "$p")

