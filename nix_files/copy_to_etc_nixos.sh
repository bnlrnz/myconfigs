#!/usr/bin/env bash 

hn=$(hostname -f)

if [ "$hn" == "nix" ]; then
    sudo cp nix-home.nix /etc/nixos/configuration.nix
    sudo cp hardware-configuration_nix-home.nix /etc/nixos/
fi

if [ "$hn" == "tp-belo" ]; then
    sudo cp nix-thinkpad.nix /etc/nixos/configuration.nix
    sudo cp hardware-configuration_nix-thinkpad.nix /etc/nixos/
fi

sudo cp packages.nix /etc/nixos/
sudo cp services.nix /etc/nixos/