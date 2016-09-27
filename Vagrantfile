# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
require 'ipaddr'

vagrant_config = YAML.load_file("provisioning/virtualbox.conf.yml")

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/xenial64"

  config.vm.synced_folder File.expand_path("k8s"), "/home/ubuntu/k8s"

  # Use the ipaddr library to calculate the netmask of a given network
  net = IPAddr.new vagrant_config['public_network']
  netmask = net.inspect().split("/")[1].split(">")[0]

  # Bring up the Devstack ovsdb/ovn-northd node on Virtualbox
  config.vm.define "k8s-master" do |k8smaster|
    k8smaster.vm.host_name = vagrant_config['k8smaster']['host_name']
    k8smaster.vm.network "private_network", ip: vagrant_config['k8smaster']['overlay-ip']
    k8smaster.vm.network "private_network", ip: vagrant_config['k8smaster']['public-ip'], netmask: netmask
    k8smaster.vm.provision "shell", path: "provisioning/setup-master.sh", privileged: false,
      :args => "#{vagrant_config['k8smaster']['overlay-ip']} #{vagrant_config['k8smaster']['public-ip']} #{vagrant_config['k8smaster']['short_name']} #{vagrant_config['k8smaster']['master-switch-subnet']}"
    k8smaster.vm.provision "shell", path: "provisioning/setup-k8s-master.sh", privileged: false,
      :args => "#{vagrant_config['k8smaster']['public-ip']} #{netmask} #{vagrant_config['public_gateway']}"
    k8smaster.vm.provider "virtualbox" do |vb|
       vb.name = vagrant_config['k8smaster']['short_name']
       vb.memory = 2048
       vb.cpus = 2
       vb.customize [
           'modifyvm', :id,
           '--nicpromisc3', "allow-all"
          ]
       vb.customize [
           "guestproperty", "set", :id,
           "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000
          ]
    end
  end

  config.vm.define "k8s-minion1" do |k8sminion1|
    k8sminion1.vm.host_name = vagrant_config['k8sminion1']['host_name']
    k8sminion1.vm.host_name = "k8sminion1"
    k8sminion1.vm.network "private_network", ip: vagrant_config['k8sminion1']['overlay-ip']
    k8sminion1.vm.network "private_network", ip: vagrant_config['k8sminion1']['public-ip'], netmask: netmask
    k8sminion1.vm.provision "shell", path: "provisioning/setup-minion.sh", privileged: false,
      :args => "#{vagrant_config['k8smaster']['overlay-ip']} #{vagrant_config['k8sminion1']['overlay-ip']} #{vagrant_config['k8smaster']['public-ip']} #{vagrant_config['k8sminion1']['short_name']} #{vagrant_config['k8sminion1']['minion-switch-subnet']}"
    k8sminion1.vm.provision "shell", path: "provisioning/setup-k8s-minion.sh", privileged: false,
      :args => "#{vagrant_config['k8smaster']['overlay-ip']}"
    k8sminion1.vm.provider "virtualbox" do |vb|
       vb.name = vagrant_config['k8sminion1']['short_name']
       vb.memory = 2048
       vb.cpus = 2
       vb.customize [
           'modifyvm', :id,
           '--nicpromisc3', "allow-all"
          ]
       vb.customize [
           "guestproperty", "set", :id,
           "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000
          ]
    end
  end

  config.vm.define "k8s-minion2" do |k8sminion2|
    k8sminion2.vm.host_name = vagrant_config['k8sminion2']['host_name']
    k8sminion2.vm.host_name = "k8sminion2"
    k8sminion2.vm.network "private_network", ip: vagrant_config['k8sminion2']['overlay-ip']
    k8sminion2.vm.network "private_network", ip: vagrant_config['k8sminion2']['public-ip'], netmask: netmask
    k8sminion2.vm.provision "shell", path: "provisioning/setup-minion.sh", privileged: false,
      :args => "#{vagrant_config['k8smaster']['overlay-ip']} #{vagrant_config['k8sminion2']['overlay-ip']} #{vagrant_config['k8smaster']['public-ip']} #{vagrant_config['k8sminion2']['short_name']} #{vagrant_config['k8sminion2']['minion-switch-subnet']}"
    k8sminion2.vm.provision "shell", path: "provisioning/setup-k8s-minion.sh", privileged: false,
      :args => "#{vagrant_config['k8smaster']['overlay-ip']}"
    k8sminion2.vm.provider "virtualbox" do |vb|
       vb.name = vagrant_config['k8sminion2']['short_name']
       vb.memory = 2048
       vb.cpus = 2
       vb.customize [
           'modifyvm', :id,
           '--nicpromisc3', "allow-all"
          ]
       vb.customize [
           "guestproperty", "set", :id,
           "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000
          ]
    end
  end
end
