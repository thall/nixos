#!/usr/bin/env bash

set -e
#set -x

cp /etc/nixos/hardware-configuration.nix .
sudo mv /etc/nixos /etc/nixos_delete_me
sudo ln -s $(pwd) /etc/nixos
