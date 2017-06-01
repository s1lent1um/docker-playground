# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.nfs.map_uid = Process.uid
  config.nfs.map_gid = Process.gid

  config.bindfs.default_options = {
    force_user:   'ubuntu',
    force_group:  'ubuntu',
    perms:        'u=rwX:g=rwD:o=rwD',
    o:"nonempty",
    chown_ignore: true,
    chgrp_ignore: true,
    chmod_ignore: true
  }

  config.vm.box = "ubuntu/xenial64"
  config.vm.network :private_network, ip: "192.168.33.50"
  config.vm.synced_folder  "../dev/", "/var/nfs", type: "nfs" #, mount_options: ['uid=1000','gid=1000']
  config.bindfs.bind_folder "/var/nfs", "/srv"

  config.vm.provision :shell, path: "vagrant/provision.sh"
  config.vm.provider "virtualbox" do |v|
    v.memory = 3072
    v.cpus = 2
  end

end
