#!/usr/bin/env bash

hn=$(hostname)

echo "Copying files for $hn (from this folder to etc)"
echo "If you don't see further output, nothing changed."

if [ "$hn" == "nix" ]; then
    if ! diff nix-home.nix /etc/nixos/configuration.nix > /dev/null ; then
        diff nix-home.nix /etc/nixos/configuration.nix
        read -n 1 -s -r -p "Press any key to overwrite /etc/nixos/nix-home"
        sudo cp -v nix-home.nix /etc/nixos/configuration.nix
    fi
    if ! diff hardware-configuration_nix-home.nix /etc/nixos/hardware-configuration_nix-home.nix > /dev/null ; then
        diff hardware-configuration_nix-home.nix /etc/nixos/hardware-configuration_nix-home.nix
        read -n 1 -s -r -p "Press any key to overwrite /etc/nixos/hardware-configuration_nix"
        sudo cp -v hardware-configuration_nix-home.nix /etc/nixos/
    fi
    if ! diff packages.nix /etc/nixos/packages.nix > /dev/null ; then
        diff packages.nix /etc/nixos/packages.nix
        read -n 1 -s -r -p "Press any key to overwrite /etc/nixos/packages.nix"
        sudo cp -v packages.nix /etc/nixos/
    fi
    if ! diff services.nix /etc/nixos/services.nix > /dev/null ; then
        diff services.nix /etc/nixos/services.nix
        read -n 1 -s -r -p "Press any key to overwrite /etc/nixos/services.nix"
        sudo cp -v services.nix /etc/nixos/
    fi
    if ! diff steam.nix /etc/nixos/steam.nix > /dev/null ; then
        diff steam.nix /etc/nixos/steam.nix
        read -n 1 -s -r -p "Press any key to overwrite /etc/nixos/steam.nix"
        sudo cp -v steam.nix /etc/nixos/
    fi
    if ! diff pwn.nix /etc/nixos/pwn.nix > /dev/null ; then
        diff pwn.nix /etc/nixos/pwn.nix
        read -n 1 -s -r -p "Press any key to overwrite /etc/nixos/pwn.nix"
        sudo cp -v pwn.nix /etc/nixos/
    fi
    if ! diff k3s.nix /etc/nixos/k3s.nix > /dev/null ; then
        diff k3s.nix /etc/nixos/k3s.nix
        read -n 1 -s -r -p "Press any key to overwrite /etc/nixos/k3s.nix"
        sudo cp -v k3s.nix /etc/nixos/
    fi
    if ! diff temis.nix /etc/nixos/temis.nix > /dev/null ; then
        diff temis.nix /etc/nixos/temis.nix
        read -n 1 -s -r -p "Press any key to overwrite /etc/nixos/temis.nix"
        sudo cp -v temis.nix /etc/nixos/
    fi
    if ! diff podman.nix /etc/nixos/podman.nix > /dev/null ; then
        diff podman.nix /etc/nixos/podman.nix
        read -n 1 -s -r -p "Press any key to overwrite /etc/nixos/podman.nix"
        sudo cp -v podman.nix /etc/nixos/
    fi
fi

if [ "$hn" == "tp-belo" ]; then
    if ! diff nix-thinkpad.nix /etc/nixos/configuration.nix > /dev/null ; then
        diff nix-thinkpad.nix /etc/nixos/configuration.nix
        read -n 1 -s -r -p "Press any key to overwrite /etc/nixos/nix-thinkpad"
        sudo cp -v nix-thinkpad.nix /etc/nixos/configuration.nix
    fi
    if ! diff hardware-configuration_nix-thinkpad.nix /etc/nixos/hardware-configuration_nix-thinkpad.nix > /dev/null ; then
        diff hardware-configuration_nix-thinkpad.nix /etc/nixos/hardware-configuration_nix-thinkpad.nix
        read -n 1 -s -r -p "Press any key to overwrite /etc/nixos/hardware-configuration_nix"
        sudo cp -v hardware-configuration_nix-thinkpad.nix /etc/nixos/
    fi
    if ! diff packages.nix /etc/nixos/packages.nix > /dev/null ; then
        diff packages.nix /etc/nixos/packages.nix
        read -n 1 -s -r -p "Press any key to overwrite /etc/nixos/packages.nix"
        sudo cp -v packages.nix /etc/nixos/
    fi
    if ! diff services.nix /etc/nixos/services.nix > /dev/null ; then
        diff services.nix /etc/nixos/services.nix
        read -n 1 -s -r -p "Press any key to overwrite /etc/nixos/services.nix"
        sudo cp -v services.nix /etc/nixos/
    fi
    if ! diff pwn.nix /etc/nixos/pwn.nix > /dev/null ; then
        diff pwn.nix /etc/nixos/pwn.nix
        read -n 1 -s -r -p "Press any key to overwrite /etc/nixos/pwn.nix"
        sudo cp -v pwn.nix /etc/nixos/
    fi
    if ! diff temis.nix /etc/nixos/temis.nix > /dev/null ; then
        diff temis.nix /etc/nixos/temis.nix
        read -n 1 -s -r -p "Press any key to overwrite /etc/nixos/temis.nix"
        sudo cp -v temis.nix /etc/nixos/
    fi
    if ! diff k3s.nix /etc/nixos/k3s.nix > /dev/null ; then
        diff k3s.nix /etc/nixos/k3s.nix
        read -n 1 -s -r -p "Press any key to overwrite /etc/nixos/k3s.nix"
        sudo cp -v k3s.nix /etc/nixos/
    fi
    if ! diff podman.nix /etc/nixos/podman.nix > /dev/null ; then
        diff podman.nix /etc/nixos/podman.nix
        read -n 1 -s -r -p "Press any key to overwrite /etc/nixos/podman.nix"
        sudo cp -v podman.nix /etc/nixos/
    fi
fi

if [ "$hn" == "nix-vps" ]; then
    if ! diff nix-vps.nix /etc/nixos/configuration.nix > /dev/null ; then
        diff nix-vps.nix /etc/nixos/configuration.nix
        read -n 1 -s -r -p "Press any key to overwrite /etc/nixos/nix-vps"
        sudo cp -v nix-vps.nix /etc/nixos/configuration.nix
    fi
    if ! diff hardware-configuration_nix-vps.nix /etc/nixos/hardware-configuration_nix-vps.nix > /dev/null ; then
        diff hardware-configuration_nix-vps.nix /etc/nixos/hardware-configuration_nix-vps.nix
        read -n 1 -s -r -p "Press any key to overwrite /etc/nixos/hardware-configuration_nix"
        sudo cp -v hardware-configuration_nix-vps.nix /etc/nixos/
    fi
    if ! diff sa3_document_manager.nix /etc/nixos/sa3_document_manager.nix > /dev/null ; then
        diff sa3_document_manager.nix /etc/nixos/sa3_document_manager.nix
        read -n 1 -s -r -p "Press any key to overwrite /etc/nixos/sa3_document_manager.nix"
        sudo cp -v sa3_document_manager.nix /etc/nixos/
    fi
    if ! diff ./secrets/secrets.yaml /etc/nixos/secrets/secrets.yaml > /dev/null ; then
        diff ./secrets/secrets.yaml /etc/nixos/secrets/secrets.yaml
        read -n 1 -s -r -p "Press any key to overwrite /etc/nixos/secrets/secrets.yaml"
        sudo cp -v -R ./secrets /etc/nixos/
    fi
fi

if [ "$hn" == "nix-pi" ]; then
    if ! diff nix-pi.nix /etc/nixos/configuration.nix > /dev/null ; then
        diff nix-pi.nix /etc/nixos/configuration.nix
        read -n 1 -s -r -p "Press any key to overwrite /etc/nixos/nix-pi"
        sudo cp -v nix-pi.nix /etc/nixos/configuration.nix
    fi
    if ! diff hardware-configuration_nix-pi.nix /etc/nixos/hardware-configuration.nix > /dev/null ; then
        diff hardware-configuration_nix-pi.nix /etc/nixos/hardware-configuration.nix
        read -n 1 -s -r -p "Press any key to overwrite /etc/nixos/hardware-configuration_nix"
        sudo cp -v hardware-configuration_nix-pi.nix /etc/nixos/hardware-configuration.nix
    fi
    if ! diff ./secrets/secrets.yaml /etc/nixos/secrets/secrets.yaml > /dev/null ; then
        diff ./secrets/secrets.yaml /etc/nixos/secrets/secrets.yaml
        read -n 1 -s -r -p "Press any key to overwrite /etc/nixos/secrets/secrets.yaml"
        sudo cp -v -R ./secrets /etc/nixos/
    fi
fi

if [ "$hn" == "nix-test" ]; then
    if ! diff nix-test.nix /etc/nixos/configuration.nix > /dev/null ; then
        diff nix-test.nix /etc/nixos/configuration.nix
        read -n 1 -s -r -p "Press any key to overwrite /etc/nixos/nix-test"
        sudo cp -v nix-test.nix /etc/nixos/configuration.nix
    fi
    if ! diff hardware-configuration_nix-test.nix /etc/nixos/hardware-configuration.nix > /dev/null ; then
        diff hardware-configuration_nix-test.nix /etc/nixos/hardware-configuration.nix
        read -n 1 -s -r -p "Press any key to overwrite /etc/nixos/hardware-configuration_nix"
        sudo cp -v hardware-configuration_nix-test.nix /etc/nixos/hardware-configuration.nix
    fi
    if ! diff temis.nix /etc/nixos/temis.nix > /dev/null ; then
        diff temis.nix /etc/nixos/temis.nix
        read -n 1 -s -r -p "Press any key to overwrite /etc/nixos/temis.nix"
        sudo cp -v temis.nix /etc/nixos/
    fi
fi


