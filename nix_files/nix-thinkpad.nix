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
    ./hardware-configuration_nix-thinkpad_throwaway.nix
    ./services.nix
    ./packages.nix
    #./pwn.nix
    #./temis.nix
    #./steam.nix
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

  
  networking.wg-quick.interfaces = {
    wghome = {
      autostart = false;
      address = [ "10.10.11.204/24" ];
      privateKey = "WKGy5X1ajWI44pa7IgNe9F5dTSOzTdX4l/p65Ww6Ckg=";
      
      peers = [
        {
          publicKey = "fzWcwGSJfsJYW6Xx/gVKB28B57Wdg9sSYrwlqV+D/F4=";
          allowedIPs = [ "0.0.0.0/0" "::/0" ];
          endpoint = "b3lo.de:51820";
          persistentKeepalive = 25;
        }
      ];
    };
    wghometunnel = {
      autostart = false;
      address = [ "10.10.11.204/24" ];
      privateKey = "WKGy5X1ajWI44pa7IgNe9F5dTSOzTdX4l/p65Ww6Ckg=";
    
      preUp = "${pkgs.wstunnel}/bin/wstunnel client --http-upgrade-path-prefix '4mtGd8IBgogyJr54ihNaTDirU4SkTqjb7dvhnRy6dcnYSUsiMgoVCqQXaHuocYcv' -L 'udp://51820:127.0.0.1:51820?timeout_sec=0' wss://tunnel.b3lo.de/& sleep 3";
      postDown = "${pkgs.killall}/bin/killall wstunnel";
        
      peers = [
        {
          publicKey = "fzWcwGSJfsJYW6Xx/gVKB28B57Wdg9sSYrwlqV+D/F4=";
          allowedIPs = [ 
            "0.0.0.0/1" "128.0.0.0/4" "144.0.0.0/6"
            "148.0.0.0/8" "149.0.0.0/10" "149.64.0.0/11"
            "149.96.0.0/14" "149.100.0.0/15" "149.102.0.0/17"
            "149.102.128.0/21" "149.102.136.0/22" "149.102.140.0/25"
            "149.102.140.128/28" "149.102.140.144/30" "149.102.140.148/31"
            "149.102.140.150/32" "149.102.140.152/29" "149.102.140.160/27"
            "149.102.140.192/26" "149.102.141.0/24" "149.102.142.0/23"
            "149.102.144.0/20" "149.102.160.0/19" "149.102.192.0/18"
            "149.103.0.0/16" "149.104.0.0/13" "149.112.0.0/12"
            "149.128.0.0/9" "150.0.0.0/7" "152.0.0.0/5"
            "160.0.0.0/3" "192.0.0.0/2" ];
          endpoint = "127.0.0.1:51820";
          persistentKeepalive = 25;
        }
      ];
    };
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
