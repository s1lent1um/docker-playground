#!/bin/bash
script_dir="$(dirname "$0")"
. /vagrant/vagrant/vagrant.sh

ensure-dir /var/vagrant

update-apt

install software-properties-common # changed in 14.04
install libpcre3-dev
install libcurl3-openssl-dev

add-docker-repository
apt-get update

install pkg-config
install git-core
install curl

#install docker-engine
install docker-compose
usermod -aG docker ubuntu

config-bash
config-hosts
config-locale


#chown -R ubuntu /vagrant


# init scripts here
cd /vagrant
#sudo -u vagrant ./install
cd -
#sudo -u vagrant ./update


exit 0