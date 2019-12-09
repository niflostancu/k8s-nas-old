#!/bin/bash
read -p "Email address: " EMAIL_ADDRESS

export EMAIL_ADDRESS
cat "$1" | envsubst '$EMAIL_ADDRESS' | kubectl apply -f -

