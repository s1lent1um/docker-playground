#!/bin/bash
script_dir="$(dirname "$0")"
. /vagrant/vagrant/vagrant.sh

ensure-dir /var/vagrant

update-apt

install software-properties-common # changed in 14.04
install libpcre3-dev
install libcurl3-openssl-dev

add-repository ppa:nginx/stable
add-php54-repository
add-docker-repository
apt-get update

install pkg-config
install git-core
install curl

install docker-engine
usermod -aG docker vagrant

config-bash
config-hosts
config-locale


chown -R vagrant /vagrant


# init scripts here
cd /vagrant
#sudo -u vagrant ./install
cd -
#sudo -u vagrant ./update


exit 0