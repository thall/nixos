#!/usr/bin/env bash

set -e
#set -x

if [ $# -lt 1 ]; then
  echo "usage $0 mbp2009|dellxps"
  exit
fi

HARDWARE_CONF=""

if [ $1 == "mbp2009" ]; then
  $HARDWARE_CONF=hardware-configuration-mbp2009.nix
elif [ $1 == "dellxps" ]; then
  $HARDWARE_CONF=hardware-configuration-dellxps.nix
else
  echo "$1.... :("
  exit 1
fi

ln -s $HARDWARE_CONF hardware-configuration.nix
sudo mv /etc/nixos /etc/nixos_delete_me
sudo ln -s $(pwd) /etc/nixos

nix-env -i mkpasswd
mkpasswd -m sha-512
