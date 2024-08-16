#!/usr/bin/env bash 

hn=$(hostname -f)

if [ "$hn" == "nix" ]; then
    sudo cp /etc/nixos/configuration.nix nix-home.nix
    sudo cp /etc/nixos/hardware-configuration_nix-home.nix hardware-configuration_nix-home.nix
fi

if [ "$hn" == "tp-belo" ]; then
    sudo cp /etc/nixos/configuration.nix nix-thinkpad.nix
    sudo cp /etc/nixos/hardware-configuration_nix-thinkpad.nix hardware-configuration_nix-thinkpad.nix 
fi

sudo cp /etc/nixos/packages.nix packages.nix
sudo cp /etc/nixos/services.nix services.nix
sudo cp /etc/nixos/steam.nix steam.nix
sudo cp /etc/nixos/pwn.nix pwn.nix