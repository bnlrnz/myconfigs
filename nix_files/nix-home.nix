# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, unstable-pkgs, lib, ... }:

let
  unstableTarball = fetchTarball
    "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration_nix-home.nix
    ./services.nix
    ./packages.nix
    ./steam.nix
    ./pwn.nix
    #./k3s.nix
    #./podman.nix
    ./temis.nix
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
  boot.loader.systemd-boot.configurationLimit = 10;

  # optimise store
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "12:15" ];

  # Enable networking
  networking.hostName = "nix";
  networking.networkmanager.enable = true;
  networking.nameservers = [
    "1.1.1.1"
    "9.9.9.9"
    "8.8.8.8"
  ];
  services.resolved.enable = true;
  networking.firewall = {
    enable = true;
    checkReversePath = false;
    allowedTCPPorts = [
      22    # SSH for pi
    ];
  };

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

  # Configure keymap in X1133, 5, 207, 22, 60, 31, 58, 15, 244
  services.xserver = {
    xkb.layout = "de";
    xkb.variant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # autologin user
  services.getty.autologinUser = "ben";

  # allow users to build packages
  nix.settings.allowed-users = [ "@wheel" "ben" ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ben = {
    isNormalUser = true;
    description = "ben";
    extraGroups = [ "networkmanager" "wheel" "audio" "wireshark" "tcpreplay" "gamemode" "pcap" "wireguard" "fuse" ];
    packages = with pkgs; [ ];
    shell = pkgs.fish;
  };
  users.defaultUserShell = pkgs.fish;

  users.users.builder = {
    description = "builder for raspi";
    isSystemUser = true;
    createHome = false;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC5gryOW0u3DjD5tyg08rTt1VK12yJ9aRoI19SumzVN9 root@nix-pi"
    ];
    group = "builder";
    uid = 500;
    shell = pkgs.bash;
  };

  users.groups.builder = {
    gid = 500;
  };

  nix.settings.trusted-users = [ "builder" ];

  security.wrappers.tcpreplay = {
    source = "${pkgs.tcpreplay}/bin/tcpreplay";
    capabilities = "cap_net_raw,cap_net_admin+eip";
    owner = "root";
    group = "tcpreplay";
    permissions = "u+rx,g+x";
  };

  # for raspi remote builds
  boot.binfmt.emulatedSystems = ["aarch64-linux"];
  nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  #virtualisation.virtualbox.host.enable = true;
  #virtualisation.virtualbox.host.enableKvm = true;
  #virtualisation.virtualbox.host.addNetworkInterface = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
