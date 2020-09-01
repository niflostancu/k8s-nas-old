#!/bin/bash
set -e

DOCKER_VERSION=18.09
K8S_VERSION=1.17.
CALICO_VERSION=3.13
NODE_IP_ADDR=$(ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}')
POD_CIDR=10.88.0.0/16

export DEBIAN_FRONTEND=noninteractive

# prerequisites
apt-get install -y apt-transport-https ca-certificates curl gnupg-agent \
	software-properties-common

find_pkg_version() {
  apt-cache madison "$1" | awk -F'|' '/|/{gsub(/ /, "", $2); print $2}' | \
    grep "$2" | head -1
}

# install docker
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

# system tuneup
# disable swap
swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# install kubernetes
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
# note: bionic is not available, probably due to it keeping compatibility
apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
apt-get update

_K8S_VERSION=$(find_pkg_version kubeadm "$K8S_VERSION")
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet=$_K8S_VERSION kubeadm=$_K8S_VERSION kubectl=$_K8S_VERSION

echo "
KUBELET_EXTRA_ARGS=--runtime-cgroups=/systemd/system.slice --kubelet-cgroups=/systemd/system.slice
" > /etc/default/kubelet

kubeadm init --apiserver-cert-extra-sans=$NODE_IP_ADDR --pod-network-cidr=${POD_CIDR}
kubeadm version
echo

# configure kubectl for root
HOME=/root
mkdir -p $HOME/.kube
cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
chown root:root $HOME/.kube/config
chmod 700 $HOME/.kube/config
echo "Kubectl configured for root."

# let the master host pods
kubectl taint nodes --all node-role.kubernetes.io/master-

# install CNI runtime for pod networking (Calico)
echo "Installing Calico CNI..."
CALICO_YAML=/tmp/k8s-calico.yml
curl -s "https://docs.projectcalico.org/v$CALICO_VERSION/manifests/calico.yaml" -o $CALICO_YAML
sed -i -e "s?192.168.0.0/16?${POD_CIDR}?g" "$CALICO_YAML"
kubectl apply -f "$CALICO_YAML"

echo
echo "K8s master successfully installed!"

