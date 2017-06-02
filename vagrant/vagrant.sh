#!/bin/bash
PROJECT_DIR="/vagrant"

CURRENT_DIR=$(pwd)

exiterr() {
  if [ "$1" -gt 0 ]; then
    if [ ! -z "$2" ]; then
      echo $2
    fi
    exit $1
  fi
}

ensure-dir() {
    if [ ! -d $1 ]; then
       mkdir -p $1
       exiterr $? "Failed to create directory $1"
    fi
}

ensure-rm() {
    if [ -f $1 ]; then
       rm -r $1
       exiterr $? "Failed to remove $1"
    fi
}

copy() {
#    echo "$@"
    cp $1 $2
    exiterr $? "Failed to copy $1 into $2"
}

installed() {
  if [ -z "$2" ]; then
    if [ -f /var/vagrant/installed-$1 ]; then
      return 0
    fi
    return 1
  fi

  touch /var/vagrant/installed-$1
}

install() {
    installed $1
    if [ "$?" -gt 0 ]; then
        apt-get install -q -y $1 || exiterr $? "$1 installation fault"
        installed $1 ok
    fi
}

configured() {
    if [ -z "$2" ]; then
      if [ -f /var/vagrant/configured-$1 ]; then
        return 0
      fi
      return 1
    fi

    touch /var/vagrant/configured-$1
}

update-apt() {
  # TODO: ttl
  configured apt-update
  if [ "$?" -gt 0 ]; then
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" --force-yes -fuy upgrade
    exiterr $? "Failed to update apt"
    configured apt-update ok
  fi
}


add-docker-repository() {
  configured docker-repository
  if [ "$?" -gt 0 ]; then
    apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
    exiterr $? "Failed to add the docker repository key"
    echo 'deb https://apt.dockerproject.org/repo ubuntu-xenial main' > /etc/apt/sources.list.d/docker.list
    configured docker-repository ok
  fi
}

add-repository() {
  alias=`echo $1 | sed 's/[\/:]/-/g'`
  configured $alias
  if [ "$?" -gt 0 ]; then
    add-apt-repository -y $1
    exiterr $? "Failed to add the $1 repository"
    configured $alias ok
  fi
}


config-hosts() {
  copy ${PROJECT_DIR}/vagrant/hosts /etc/hosts
}

config-bash() {
  copy ${PROJECT_DIR}/vagrant/.bashrc ~ubuntu/.bashrc
}

config-sysctl() {
  copy ${PROJECT_DIR}/vagrant/sysctl.conf /etc/sysctl.d/10-vagrant-sysctl.conf
  sysctl -p /etc/sysctl.d/10-vagrant-sysctl.conf
}


config-locale() {
  configured locale
  if [ "$?" -gt 0 ]; then
    locale-gen ru_RU.UTF-8
    exiterr $? "Failed to generate locale ru_RU.UTF-8"
    sed -i "s/LC_ALL=\"en_US\"/LC_ALL=\"ru_RU.UTF-8\"/" /etc/default/locale
    exiterr $? "Failed to replace locale into /etc/default/locale"
    dpkg-reconfigure --default-priority locales
    exiterr $? "Failed to reconfigure locale"
    configured locale ok
  fi
}
