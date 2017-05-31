# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.network :private_network, ip: "192.168.33.50"
  config.vm.synced_folder  "./", "/srv", type: "nfs"
  config.vm.provision :shell, path: "vagrant/provision.sh"
end