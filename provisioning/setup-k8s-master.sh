#!/bin/bash

# Save trace setting
XTRACE=$(set +o | grep xtrace)
set -o xtrace

# args:
# $1: The gateway IP to use
# $2: The default GW for the GW device

PUBLIC_IP=$1
GW_IP=$2

# First, install docker
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo su -c "echo \"deb https://apt.dockerproject.org/repo ubuntu-xenial main\" >> /etc/apt/sources.list.d/docker.list"
sudo apt-get update
sudo apt-get purge lxc-docker
sudo apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual
sudo apt-get install -y docker-engine
sudo service docker start

# Install k8s

# Install an etcd cluster
sudo docker run --net=host -d gcr.io/google_containers/etcd:2.0.12 /usr/local/bin/etcd \
                --addr=127.0.0.1:4001 --bind-addr=0.0.0.0:4001 --data-dir=/var/etcd/data

# Download Kubernetes ... yes, it's huge
#mkdir k8s
#pushd k8s
#wget https://github.com/kubernetes/kubernetes/releases/download/v1.3.7/kubernetes.tar.gz
#tar xvzf kubernetes.tar.gz

# Now untar kubernetes-server-linux-amd64.tar.gz
#mkdir server
#cd server
#tar xvzf ../kubernetes/server/linux/kubernetes-server-linux-amd64.tar.gz
#popd

# Start k8s daemons
pushd k8s/server/kubernetes/server/bin
echo "Starting kube-apiserver ..."
nohup sudo ./kube-apiserver --service-cluster-ip-range=192.168.200.0/24 \
                            --address=0.0.0.0 --etcd-servers=http://127.0.0.1:4001 \
                            --v=2 2>&1 0<&- &>/dev/null &
sleep 5

echo "Starting kube-controller-manager ..."
nohup sudo ./kube-controller-manager --master=127.0.0.1:8080 --v=2 2>&1 0<&- &>/dev/null &
sleep 5

echo "Starting kube-scheduler ..."
nohup sudo ./kube-scheduler --master=127.0.0.1:8080 --v=2 2>&1 0<&- &>/dev/null &
sleep 5

echo "Starting ovn-k8s-watcher ..."
sudo ovn-k8s-watcher --overlay --pidfile --log-file -vfile:info -vconsole:emer --detach

# Setup the GW node on the master
sudo ovn-k8s-overlay gateway-init --cluster-ip-subnet="192.168.0.0/16" --physical-interface enp0s9 \
                                  --physical-ip $PUBLIC_IP --node-name="kube-gateway-node1" --default-gw $GW_IP

# Restore xtrace
$XTRACE
