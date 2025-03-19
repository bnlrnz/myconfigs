#!/usr/bin/env bash

hn=$(hostname)

echo "Copying files for $hn"

if [ "$hn" == "nix" ]; then
    sudo cp -v nix-home.nix /etc/nixos/configuration.nix
    sudo cp -v hardware-configuration_nix-home.nix /etc/nixos/
    sudo cp -v packages.nix /etc/nixos/
    sudo cp -v services.nix /etc/nixos/
    sudo cp -v steam.nix /etc/nixos/
    sudo cp -v pwn.nix /etc/nixos/
    sudo cp -v k3s.nix /etc/nixos/
    sudo cp -v temis.nix /etc/nixos/
    sudo cp -v podman.nix /etc/nixos/
fi

if [ "$hn" == "tp-belo" ]; then
    sudo cp -v nix-thinkpad.nix /etc/nixos/configuration.nix
    sudo cp -v hardware-configuration_nix-thinkpad.nix /etc/nixos/
    sudo cp -v packages.nix /etc/nixos/
    sudo cp -v services.nix /etc/nixos/
    sudo cp -v pwn.nix /etc/nixos/
    sudo cp -v temis.nix /etc/nixos/
    sudo cp -v k3s.nix /etc/nixos/
    sudo cp -v podman.nix /etc/nixos/
fi

if [ "$hn" == "nix-vps" ]; then
    sudo cp -v nix-vps.nix /etc/nixos/configuration.nix
    sudo cp -v hardware-configuration_nix-vps.nix /etc/nixos/
fi

if [ "$hn" == "nix-pi" ]; then
    sudo cp -v nix-pi.nix /etc/nixos/configuration.nix
    sudo cp -v hardware-configuration_nix-pi.nix /etc/nixos/hardware-configuration.nix
fi
