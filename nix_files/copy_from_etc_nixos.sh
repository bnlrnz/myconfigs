#!/usr/bin/env bash

hn=$(hostname)

echo "Copying files for $hn"

if [ "$hn" == "nix" ]; then
    sudo cp -v /etc/nixos/configuration.nix nix-home.nix
    sudo cp -v /etc/nixos/hardware-configuration_nix-home.nix hardware-configuration_nix-home.nix
    sudo cp -v /etc/nixos/packages.nix packages.nix
    sudo cp -v /etc/nixos/services.nix services.nix
    sudo cp -v /etc/nixos/steam.nix steam.nix
    sudo cp -v /etc/nixos/pwn.nix pwn.nix
    sudo cp -v /etc/nixos/k3s.nix k3s.nix
    sudo cp -v /etc/nixos/temis.nix temis.nix
fi

if [ "$hn" == "tp-belo" ]; then
    sudo cp -v /etc/nixos/configuration.nix nix-thinkpad.nix
    sudo cp -v /etc/nixos/hardware-configuration_nix-thinkpad.nix hardware-configuration_nix-thinkpad.nix
    sudo cp -v /etc/nixos/packages.nix packages.nix
    sudo cp -v /etc/nixos/services.nix services.nix
    sudo cp -v /etc/nixos/pwn.nix pwn.nix
    sudo cp -v /etc/nixos/temis.nix temis.nix
    sudo cp -v /etc/nixos/k3s.nix k3s.nix

fi

if [ "$hn" == "nix-vps" ]; then
    sudo cp -v /etc/nixos/configuration.nix nix-vps.nix
    sudo cp -v /etc/nixos/hardware-configuration_nix-vps.nix hardware-configuration_nix-vps.nix
    sudo cp -v /etc/nixos/wed_web.nix wed_web.nix
fi

if [ "$hn" == "nix-pi" ]; then
    sudo cp -v /etc/nixos/configuration.nix nix-pi.nix
    sudo cp -v /etc/nixos/hardware-configuration.nix hardware-configuration_nix-pi.nix
fi
