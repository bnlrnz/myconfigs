#!/usr/bin/env bash

hn=$(hostname)

echo "Copying files for $hn (from etc to this folder)"
echo "If you don't see further output, nothing changed."

if [ "$hn" == "nix" ]; then
    if ! diff /etc/nixos/configuration.nix nix-home.nix > /dev/null ; then
        diff /etc/nixos/configuration.nix nix-home.nix
        read -n 1 -s -r -p "Press any key to overwrite nix-home.nix"
        sudo cp -v /etc/nixos/configuration.nix nix-home.nix
    fi
    
    if ! diff /etc/nixos/hardware-configuration_nix-home.nix hardware-configuration_nix-home.nix > /dev/null ; then
        diff /etc/nixos/hardware-configuration_nix-home.nix hardware-configuration_nix-home.nix
        read -n 1 -s -r -p "Press any key to overwrite hardware-configuration_nix-home.nix"
        sudo cp -v /etc/nixos/hardware-configuration_nix-home.nix hardware-configuration_nix-home.nix
    fi
    
    if ! diff /etc/nixos/packages.nix packages.nix > /dev/null ; then
        diff /etc/nixos/packages.nix packages.nix
        read -n 1 -s -r -p "Press any key to overwrite packages.nix"
        sudo cp -v /etc/nixos/packages.nix packages.nix
    fi
    
    if ! diff /etc/nixos/services.nix services.nix > /dev/null ; then
        diff /etc/nixos/services.nix services.nix
        read -n 1 -s -r -p "Press any key to overwrite services.nix"
        sudo cp -v /etc/nixos/services.nix services.nix
    fi
    
    if ! diff /etc/nixos/steam.nix steam.nix > /dev/null ; then
        diff /etc/nixos/steam.nix steam.nix
        read -n 1 -s -r -p "Press any key to overwrite steam.nix"
        sudo cp -v /etc/nixos/steam.nix steam.nix
    fi
    
    if ! diff /etc/nixos/pwn.nix pwn.nix > /dev/null ; then
        diff /etc/nixos/pwn.nix pwn.nix
        read -n 1 -s -r -p "Press any key to overwrite pwn.nix"
        sudo cp -v /etc/nixos/pwn.nix pwn.nix
    fi
    
    if ! diff /etc/nixos/k3s.nix k3s.nix > /dev/null ; then
        diff /etc/nixos/k3s.nix k3s.nix
        read -n 1 -s -r -p "Press any key to overwrite k3s.nix"
        sudo cp -v /etc/nixos/k3s.nix k3s.nix
    fi
    
    if ! diff /etc/nixos/temis.nix temis.nix > /dev/null ; then
        diff /etc/nixos/temis.nix temis.nix
        read -n 1 -s -r -p "Press any key to overwrite temis.nix"
        sudo cp -v /etc/nixos/temis.nix temis.nix
    fi
    
    if ! diff /etc/nixos/podman.nix podman.nix > /dev/null ; then
        diff /etc/nixos/podman.nix podman.nix
        read -n 1 -s -r -p "Press any key to overwrite podman.nix"
        sudo cp -v /etc/nixos/podman.nix podman.nix
    fi
    
fi

if [ "$hn" == "tp-belo" ]; then
    if ! diff /etc/nixos/configuration.nix nix-thinkpad.nix > /dev/null ; then
        diff /etc/nixos/configuration.nix nix-thinkpad.nix
        read -n 1 -s -r -p "Press any key to overwrite nix-thinkpad.nix"
        sudo cp -v /etc/nixos/configuration.nix nix-thinkpad.nix
    fi
    
    if ! diff /etc/nixos/hardware-configuration_nix-thinkpad.nix hardware-configuration_nix-thinkpad.nix > /dev/null ; then
        diff /etc/nixos/hardware-configuration_nix-thinkpad.nix hardware-configuration_nix-thinkpad.nix
        read -n 1 -s -r -p "Press any key to overwrite hardware-configuration_nix-thinkpad.nix"
        sudo cp -v /etc/nixos/hardware-configuration_nix-thinkpad.nix hardware-configuration_nix-thinkpad.nix
    fi
    
    if ! diff /etc/nixos/packages.nix packages.nix > /dev/null ; then
        diff /etc/nixos/packages.nix packages.nix
        read -n 1 -s -r -p "Press any key to overwrite packages.nix"
        sudo cp -v /etc/nixos/packages.nix packages.nix
    fi
    
    if ! diff /etc/nixos/services.nix services.nix > /dev/null ; then
        diff /etc/nixos/services.nix services.nix
        read -n 1 -s -r -p "Press any key to overwrite services.nix"
        sudo cp -v /etc/nixos/services.nix services.nix
    fi
    
    if ! diff /etc/nixos/pwn.nix pwn.nix > /dev/null ; then
        diff /etc/nixos/pwn.nix pwn.nix
        read -n 1 -s -r -p "Press any key to overwrite pwn.nix"
        sudo cp -v /etc/nixos/pwn.nix pwn.nix
    fi
    
    if ! diff /etc/nixos/temis.nix temis.nix > /dev/null ; then
        diff /etc/nixos/temis.nix temis.nix
        read -n 1 -s -r -p "Press any key to overwrite temis.nix"
        sudo cp -v /etc/nixos/temis.nix temis.nix
    fi
    
    if ! diff /etc/nixos/k3s.nix k3s.nix > /dev/null ; then
        diff /etc/nixos/k3s.nix k3s.nix
        read -n 1 -s -r -p "Press any key to overwrite k3s.nix"
        sudo cp -v /etc/nixos/k3s.nix k3s.nix
    fi
    
    if ! diff /etc/nixos/podman.nix podman.nix > /dev/null ; then
        diff /etc/nixos/podman.nix podman.nix
        read -n 1 -s -r -p "Press any key to overwrite podman.nix"
        sudo cp -v /etc/nixos/podman.nix podman.nix
    fi
    
fi

if [ "$hn" == "nix-vps" ]; then
    if ! diff /etc/nixos/configuration.nix nix-vps.nix > /dev/null ; then
        diff /etc/nixos/configuration.nix nix-vps.nix
        read -n 1 -s -r -p "Press any key to overwrite nix-vps.nix"
        sudo cp -v /etc/nixos/configuration.nix nix-vps.nix
    fi
    
    if ! diff /etc/nixos/hardware-configuration_nix-vps.nix hardware-configuration_nix-vps.nix > /dev/null ; then
        diff /etc/nixos/hardware-configuration_nix-vps.nix hardware-configuration_nix-vps.nix
        read -n 1 -s -r -p "Press any key to overwrite hardware-configuration_nix-vps.nix"
        sudo cp -v /etc/nixos/hardware-configuration_nix-vps.nix hardware-configuration_nix-vps.nix
    fi
    
    if ! diff /etc/nixos/sa3_document_manager.nix sa3_document_manager.nix > /dev/null ; then
        diff /etc/nixos/sa3_document_manager.nix sa3_document_manager.nix
        read -n 1 -s -r -p "Press any key to overwrite sa3_document_manager.nix"
        sudo cp -v /etc/nixos/sa3_document_manager.nix sa3_document_manager.nix
    fi
    
fi

if [ "$hn" == "nix-pi" ]; then
    if ! diff /etc/nixos/configuration.nix nix-pi.nix > /dev/null ; then
        diff /etc/nixos/configuration.nix nix-pi.nix
        read -n 1 -s -r -p "Press any key to overwrite nix-pi.nix"
        sudo cp -v /etc/nixos/configuration.nix nix-pi.nix
    fi
    
    if ! diff /etc/nixos/hardware-configuration.nix hardware-configuration_nix-pi.nix > /dev/null ; then
        diff /etc/nixos/hardware-configuration.nix hardware-configuration_nix-pi.nix
        read -n 1 -s -r -p "Press any key to overwrite hardware-configuration_nix-pi.nix"
        sudo cp -v /etc/nixos/hardware-configuration.nix hardware-configuration_nix-pi.nix
    fi
    
fi

if [ "$hn" == "nix-test" ]; then
    if ! diff /etc/nixos/configuration.nix nix-test.nix > /dev/null ; then
        diff /etc/nixos/configuration.nix nix-test.nix
        read -n 1 -s -r -p "Press any key to overwrite nix-test.nix"
        sudo cp -v /etc/nixos/configuration.nix nix-test.nix
    fi
    
    if ! diff /etc/nixos/hardware-configuration.nix hardware-configuration_nix-test.nix > /dev/null ; then
        diff /etc/nixos/hardware-configuration.nix hardware-configuration_nix-test.nix
        read -n 1 -s -r -p "Press any key to overwrite hardware-configuration_nix-test.nix"
        sudo cp -v /etc/nixos/hardware-configuration.nix hardware-configuration_nix-test.nix
    fi
    
fi
