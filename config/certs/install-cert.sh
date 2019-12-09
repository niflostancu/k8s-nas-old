#!/bin/bash

cat "$1" | envsubst '$EMAIL_ADDRESS' | kubectl apply -f -


