Kubernetes and OVN
==================

This contains a Vagrant setup for Kubernetes and OVN integration.

Howto
-----

Pull down Kubernetes (it's big)

* mkdir k8s
* cd k8s
* wget https://github.com/kubernetes/kubernetes/releases/download/v1.3.7/kubernetes.tar.gz
* #tar xvzf kubernetes.tar.gz
* mkdir server
* cd server
* tar xvzf ../kubernetes/server/linux/kubernetes-server-linux-amd64.tar.gz

Bringup the Vagrant setup

* vagrant up

Create a pod
------------

Grab a sample [node-js-hello][1] container and try this all out! Follow the
instructions below, which are loosely based on those found [here][2].

On the master node, run the following:

* cd k8s/server/kubernetes/server/bin
* ./kubectl run hello-node --image=google/nodejs-hello --port=8080
* ./kubectl expose deployment hello-node --type="LoadBalancer"

Verify the external IP:

* ./kubectl get services hello-node

[1]: https://hub.docker.com/r/google/nodejs-hello/
[2]: http://kubernetes.io/docs/hellonode/

References
----------

https://github.com/openvswitch/ovn-kubernetes
