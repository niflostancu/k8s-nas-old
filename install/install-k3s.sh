#!/bin/bash
# K3S installation script.
set -e

K3S_CONFIG="config/k3s/k3s-node.yaml"
[[ -f "$K3S_CONFIG" ]] || {
  echo "This script must be ran from project's root!">&2; exit 1;
}

# copy this node's k3s config descriptor
sudo mkdir -p /etc/rancher/k3s/
sudo cp -f "$K3S_CONFIG" /etc/rancher/k3s/config.yaml

# install k3s master
curl -sfL https://get.k3s.io | sudo sh -

sudo cp -rf config/k3s/manifests/* /var/lib/rancher/k3s

