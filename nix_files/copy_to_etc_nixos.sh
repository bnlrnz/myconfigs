#!/usr/bin/env bash

hn=$(hostname)

echo "Copying files for $hn (from this folder to etc)"
echo "If you don't see further output, nothing changed."

# Machine-specific file lists
declare -a NIX_HOME_FILES=(
    "nix-home.nix:configuration.nix"
    "hardware-configuration_nix-home.nix"
    "packages.nix"
    "services.nix"
    "steam.nix"
    "pwn.nix"
    "k3s.nix"
    "temis.nix"
    "podman.nix"
)

declare -a TP_BELO_FILES=(
    "nix-thinkpad.nix:configuration.nix"
    "hardware-configuration_nix-thinkpad.nix"
    "packages.nix"
    "services.nix"
    "steam.nix"
    "pwn.nix"
    "k3s.nix"
    "temis.nix"
    "podman.nix"
)

declare -a NIX_VPS_FILES=(
    "nix-vps.nix:configuration.nix"
    "hardware-configuration_nix-vps.nix"
    "service_sa3_document_manager.nix"
    "secrets/secrets.yaml:secrets/secrets.yaml"
    "service_wireguard.nix"
    "service_mailserver.nix"
    "service_immich.nix"
    "service_n8n.nix"
    "service_nextcloud.nix"
    "service_onlyoffice.nix"
)

declare -a NIX_PI_FILES=(
    "nix-pi.nix:configuration.nix"
    "hardware-configuration_nix-pi.nix"
    "secrets/secrets.yaml:secrets/secrets.yaml"
)

declare -a NIX_TEST_FILES=(
    "nix-test.nix:configuration.nix"
    "hardware-configuration_nix-test.nix"
    "temis.nix"
)

# Function to sync a file
sync_file() {
    local source="$1"
    local dest_name="$2"
    local destination="/etc/nixos/$dest_name"
    
    if ! diff "$source" "$destination" > /dev/null 2>&1; then
        diff "$source" "$destination"
        read -n 1 -s -r -p "Press any key to overwrite $destination"
        
        # Check if it's a directory (for secrets/) and use -R flag
        if [ -d "$source" ]; then
            sudo cp -v -R "$source" "$destination"
        else
            sudo cp -v "$source" "$destination"
        fi
    fi
}

# Function to process a machine's file list
process_machine() {
    local -n files_array=$1
    
    for file_pair in "${files_array[@]}"; do
        # Split source and destination
        if [[ "$file_pair" == *":"* ]]; then
            IFS=':' read -r source dest <<< "$file_pair"
        else
            source="$file_pair"
            dest="$file_pair"
        fi
        
        sync_file "$source" "$dest"
    done
}

# Main logic
sudo mkdir /etc/nixos/secrets # just to be sure, even if we do not need it
case "$hn" in
    "nix") process_machine NIX_HOME_FILES ;;
    "nix-vps") process_machine NIX_VPS_FILES ;;
    "tp-belo") process_machine TP_BELO_FILES ;;
    "nix-pi") process_machine NIX_PI_FILES ;;
    "nix-test") process_machine NIX_TEST_FILES ;;
    *)
    echo "Unknown hostname: $hn"
    exit 1 ;;
esac
