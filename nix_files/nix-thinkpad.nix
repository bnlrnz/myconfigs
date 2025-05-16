# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, unstable-pkgs, lib, ... }:

let
  # unstable packages
  unstableTarball = fetchTarball
    "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";

  # integrated home-manager module... not used for now
  #home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz;

  # auto login script only for tty1 and belo
  script = pkgs.writeText "login-program.sh" ''
    if [[ "$(tty)" == '/dev/tty1' ]]; then
      ${pkgs.shadow}/bin/login -f belo;
    else
      ${pkgs.shadow}/bin/login;
    fi
  '';
  batteryCheckScript = ''
    #!${pkgs.bash}/bin/bash
    BAT_PCT=$(${pkgs.acpi}/bin/acpi -b | ${pkgs.gnugrep}/bin/grep -P -o '[0-9]+(?=%)')
    BAT_STA=$(${pkgs.acpi}/bin/acpi -b | ${pkgs.gnugrep}/bin/grep -P -o '\w+(?=,)')
    echo "$(date) battery status:$BAT_STA percentage:$BAT_PCT"
    if [ "$BAT_PCT" -le 15 ] && [ "$BAT_PCT" -gt 5 ] && [ "$BAT_STA" = "Discharging" ]; then
      DISPLAY=:0.0 ${pkgs.libnotify}/bin/notify-send -c device -u critical "󰁺 Low Battery" "Would be wise to keep my charger nearby."
    fi
    if [ "$BAT_PCT" -le 5 ] && [ "$BAT_STA" = "Discharging" ]; then
      DISPLAY=:0.0 ${pkgs.libnotify}/bin/notify-send -c device -u critical "󰁺 Low Battery" "Charge me or watch me die!"
    fi
  '';
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration_nix-thinkpad.nix
    ./services.nix
    ./packages.nix
    ./pwn.nix
    ./temis.nix
    #./k3s.nix
    #(import "${home-manager}/nixos")
  ];

  # add unstable channel
  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball { config = config.nixpkgs.config; };
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Limit generations
  boot.loader.systemd-boot.configurationLimit = 20;

  # Enable networking
  networking.hostName = "tp-belo"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;
  networking.nameservers = [
    "1.1.1.1"
    "9.9.9.9"
    "8.8.8.8"
  ];
  services.resolved.enable = true;
  networking.firewall.enable = true;
    
  # Whether to enable captive browser, a dedicated Chrome instance to log into captive portals without messing with DNS settings.
  programs.captive-browser.enable = true;
  programs.captive-browser.interface = "wlp0s20f3";

  # Generate an immutable /etc/resolv.conf from the nameserver settings
  # above (otherwise DHCP overwrites it):
  #environment.etc."resolv.conf" = with lib; with pkgs; {
  #  source = writeText "resolv.conf" ''
  #    ${concatStringsSep "\n" (map (ns: "nameserver ${ns}") config.networking.nameservers)}
  #    options edns0
  #    options timeout:1
  #  '';
  #};

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure console keymap
  console.keyMap = "de";

  # services.getty.autologinUser = "belo"; 
  services.getty = {
    loginProgram = "${pkgs.bash}/bin/sh";
    loginOptions = toString script;
    extraArgs = [ "--skip-login" ];
  };

  # allow users to build packages
  nix.settings.allowed-users = [ "@wheel" "belo" ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.belo = {
    isNormalUser = true;
    description = "belo";
    extraGroups = [ "networkmanager" "wheel" "audio" "wireshark" "wireguard" "tcpreplay" "kubeusers" ];
    packages = with pkgs; [ ];
    shell = pkgs.fish;
  };
  users.defaultUserShell = pkgs.fish;

  systemd.user.services.battery-alert = {
    description = "Battery Status Notifier";
    after = [ "graphical-session.target" ];
    wantedBy = [ "default.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.writeShellScript "battery-check" batteryCheckScript}";
      Type = "oneshot";
    };
  };

  systemd.user.timers.battery-alert = {
    description = "Timer for battery alert";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5min";
      OnUnitActiveSec = "5min";
      Unit = "battery-alert.service";
    };
  };

  security.wrappers.tcpreplay = {
    source = "${pkgs.tcpreplay}/bin/tcpreplay";
    capabilities = "cap_net_raw,cap_net_admin+eip";
    owner = "root";
    group = "tcpreplay";
    permissions = "u+rx,g+x";
  };

  # integrated home-manager module... not used for now
  #home-manager.users.belo = {
  #  home.stateVersion = "24.11";
  #};

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
