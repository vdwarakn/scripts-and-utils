#!/bin/bash
## Script to install Docker, Kubernetes and Habana Runtime

## Setup APT repo for Docker
wget -q -O- https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/docker.gpg
echo "deb https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
 
## Setup APT repo for kubectl and kubernetes engine
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/kubernetes-apt-keyring.gpg
echo "deb  https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /" > /etc/apt/sources.list.d/kubernetes.list

## Cleanup Habana key ring to remove a warning when runing apt
#apt-key export 36A2DE65 | gpg --dearmour -o /etc/apt/trusted.gpg.d/habana.gpg
if [ -f /etc/apt/trusted.gpg ]; then
	mv -f /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d/habana.gpg
fi

## Install required packages
apt update
apt -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
apt -y install etcd-client containerd.io kubelet kubeadm kubectl

## Configure docker daemon with proxy and habana-runtime
isGaudi=$(lspci | grep -ic habana)
echo "isGaudi = ${isGaudi}"

DAEMON_JSON=/etc/docker/daemon.json
SYSCTL_DOCKER=/etc/systemd/system/docker.service.d
SYSCTL_CONTAINERD=/etc/systemd/system/containerd.service.d

## Create directories
mkdir -p $SYSCTL_DOCKER
mkdir -p $SYSCTL_CONTAINERD

if [ $isGaudi -eq 0 ]; then
	apt -y install habanalabs-container-runtime
	cp docker-gaudi-proxy.json -O $DAEMON_JSON
fi

## Configure containerD to use proxy
cp systemctl-containerd.conf -O $SYSCTL_CONTAINERD/override.conf

## Configure systemctl
cp 90-sysctl-ipforward-enable.conf -O /etc/sysctl.d/90-sysctl-ipforward-enable.conf
sysctl -p --system

systemctl daemon-reload
systemctl enable containerd
systemctl restart containerd
cp config.toml -O /etc/containerd/config.toml

systemctl restart containerd
systemctl enable --now kubelet


## Cleaning up
apt -y autoremove
