#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive

# prerequisites
apt-get install -y apt-transport-https ca-certificates curl gnupg-agent \
	software-properties-common

# install docker ?
if false; then
  # see https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-repository
  apt-get install -y apt-transport-https software-properties-common
  wget -qO- https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

  apt-get update
  _DOCKER_CE_VERSION=$(find_pkg_version docker-ce "$DOCKER_VERSION")
  apt-get install -y docker-ce=$_DOCKER_CE_VERSION
  cat > /etc/docker/daemon.json <<EOF
  {
    "exec-opts": ["native.cgroupdriver=systemd"],
    "log-driver": "json-file",
    "log-opts": {
      "max-size": "100m"
    },
    "storage-driver": "overlay2"
  }
EOF

  mkdir -p /etc/systemd/system/docker.service.d
  systemctl daemon-reload
  systemctl restart docker
  systemctl enable docker

  # Enable systemd accounting
  mkdir -p /etc/systemd/system.conf.d
  cat <<EOF >/etc/systemd/system.conf.d/kubernetes-accounting.conf
  [Manager]
  DefaultCPUAccounting=yes
  DefaultMemoryAccounting=yes  
EOF
fi

# system tuneup
# disable swap
swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Install hd-idle
wget https://github.com/adelolmo/hd-idle/releases/download/v1.15/hd-idle_1.15_amd64.deb
dpkg -i "hd-idle_"*"_amd64.deb"
cp -f "config/system/hd-idle.conf" /etc/default/hd-idle

echo
echo "Base successfully installed!"

