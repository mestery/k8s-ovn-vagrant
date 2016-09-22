Kubernetes and OVN
==================

This contains a Vagrant setup for Kubernetes and OVN integration.

Howto
-----

Pull down Kubernetes (it's big)

* cd k8s
* wget https://github.com/kubernetes/kubernetes/releases/download/v1.3.7/kubernetes.tar.gz
* #tar xvzf kubernetes.tar.gz
* mkdir server
* cd server
* tar xvzf ../kubernetes/server/linux/kubernetes-server-linux-amd64.tar.gz

Bringup the Vagrant setup

* vagrant up

References
----------

https://github.com/openvswitch/ovn-kubernetes
