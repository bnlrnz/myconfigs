# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, unstable-pkgs, lib, ... }:

let
  # unstable packages
  unstableTarball = fetchTarball
    "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";

  # auto login script only for tty1 and belo
  script = pkgs.writeText "login-program.sh" ''
    if [[ "$(tty)" == '/dev/tty1' ]]; then
      ${pkgs.shadow}/bin/login -f belo;
    else
      ${pkgs.shadow}/bin/login;
    fi
  '';

  # the bsi ctf host ip
  ctf_ip = "10.13.37.10";
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration_nix-thinkpad.nix
    ./services.nix
    ./packages.nix
    ./pwn.nix
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
  networking.nameservers = [
    "1.1.1.1"
    #"10.50.1.1"
    #"172.20.10.1"
    "9.9.9.9"
    "8.8.8.8"
  ];
  networking.resolvconf.enable = true;
  networking.firewall = {
    enable = true;
    checkReversePath = false;
    allowedUDPPorts = [ 4431 ]; # openfortivpn -> 4431
  };

  # Generate an immutable /etc/resolv.conf from the nameserver settings
  # above (otherwise DHCP overwrites it):
  #environment.etc."resolv.conf" = with lib; with pkgs; {
  #  source = writeText "resolv.conf" ''
  #    ${concatStringsSep "\n" (map (ns: "nameserver ${ns}") config.networking.nameservers)}
  #    options edns0
  #    options timeout:1
  #  '';
  #};

  # ctf hosts
  networking.extraHosts =
    ''
      ${ctf_ip} vault.starfleet
      ${ctf_ip} medical.starfleet
      ${ctf_ip} crusher.starfleet
      ${ctf_ip} reynholm.industries
      ${ctf_ip} bornholm.reynholm.industries
      ${ctf_ip} recruiting.reynholm.industries
      ${ctf_ip} recruiter2.reynholm.industries
      ${ctf_ip} ldap.reynholm.industries
      ${ctf_ip} cdn.reynholm.industries
      ${ctf_ip} ns1.reynholm.industries
      ${ctf_ip} weird.reynholm.industries
      ${ctf_ip} usersearch.reynholm.industries
    '';

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
    extraGroups = [ "networkmanager" "wheel" "audio" "wireshark" "tcpreplay" ];
    packages = with pkgs; [ ];
    shell = pkgs.fish;
  };
  users.defaultUserShell = pkgs.fish;

  #security.wrappers.dumpcap = {
  #  source = lib.mkDefault "${pkgs.unstable.wireshark}/bin/dumpcap";
  #  capabilities = "cap_net_raw,cap_net_admin+eip";
  #  owner = "root";
  #  group = "wireshark";
  #  permissions = "u+rx,g+x";
  #};

  security.wrappers.tcpreplay = {
    source = "${pkgs.tcpreplay}/bin/tcpreplay";
    capabilities = "cap_net_raw,cap_net_admin+eip";
    owner = "root";
    group = "tcpreplay";
    permissions = "u+rx,g+x";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
