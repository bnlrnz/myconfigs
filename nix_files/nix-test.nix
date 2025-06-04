# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, unstable-pkgs, lib, ... }:

let
  # unstable packages
  unstableTarball = fetchTarball
    "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./temis.nix	
  ];

  # add unstable channel
  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball { config = config.nixpkgs.config; };
    };
  };

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Limit generations
  boot.loader.grub.configurationLimit = 1;

  # automatic store optimization
  nix.optimise.automatic = true;

  # garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  virtualisation.virtualbox.guest.enable = true;

  # Enable networking
  networking.hostName = "nix-test"; # Define your hostname.
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
  programs.captive-browser.interface = "enp0s3";

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

  services.getty.autologinUser = "belo"; 

  # allow users to build packages
  nix.settings.allowed-users = [ "@wheel" "belo" ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.belo = {
    isNormalUser = true;
    description = "belo";
    extraGroups = [ "networkmanager" "wheel" "audio" "wireshark" "wireguard" ];
    packages = with pkgs; [ ];
    shell = pkgs.fish;
  };
  users.defaultUserShell = pkgs.fish;
  
  # allow nix flakes  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.libinput.enable = true;
  
  services.xserver.enable = true;
  services.xserver.xkb.layout = "de";
  services.xserver.xkb.variant = "nodeadkeys";
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "belo";
  services.xserver.displayManager.lightdm = {
  	enable = true;
	greeters.gtk = {
		enable = true;
		theme.name = "Dracula";
		theme.package = pkgs.dracula-theme;
		iconTheme.name = "Dracula";
		iconTheme.package = pkgs.dracula-icon-theme;
		cursorTheme.name = "Phinger Cursors (light)";
		cursorTheme.package = pkgs.phinger-cursors;
  	};
  };
  services.xserver.desktopManager.lxqt.enable = true;
  xdg.portal.lxqt.enable = true;

  # kwallet needed by python keyring
  #security.pam.services.kdewallet.enableKwallet = true;
  security.pam.services.xscreensaver.enable = true;

  # enable pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Audio for apps
  nixpkgs.config.pulseaudio = true;

  # automount usb
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # enable fwupd -> fwupdmgr
  services.fwupd.enable = true;

  # enable fish
  programs.fish.enable = true;
  
  # gnome settings/themes
  programs.dconf.enable = true;

  # setup thunar
  programs.thunar.enable = true;
  programs.xfconf.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  programs.file-roller.enable = true;

  # for thumbnails
  services.tumbler.enable = true;

  qt.platformTheme = "lxqt";

  # enable polkit
  security.polkit.enable = true;
	
  # gnome keyring is needed for network manager to store VPN passwords
  services.gnome.gnome-keyring.enable = true;

  # Allow unfree packages
  # nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "webex"
      "libsciter"
      "vscode"
      "corefonts"
      "vista-fonts"
  ];
  
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      font-awesome
      #nerdfonts
      source-han-sans
      open-sans
      google-fonts
      corefonts
      vistafonts
    ];
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" "Source Han Serif" ];
      sansSerif = [ "Open Sans" "Source Han Sans" ];
      emoji = [ "Noto Color Emoji" ];
    };
    enableDefaultPackages = true;
  };

  # shared libs
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    libcxx
    libpcap
    openssl
    stdenv.cc.cc
    zlib
    fuse3
    curl
  ];

  environment.systemPackages = with pkgs; [
    ### unfree packages
    vscode
    ###
    alsa-utils
    arandr
    autofs5
    bat
    bind
    btop
    btrfs-progs
    cairo.dev
    cliphist
    cpuid
    curl
    dconf
    desktop-file-utils
    du-dust
    dracula-theme
    dracula-icon-theme
    exfat
    exfatprogs
    eza
    feh
    filezilla
    firefox
    fish
    fzf
    font-awesome
    ghex
    gio-sharp
    git
    dconf-editor
    gsettings-desktop-schemas
    gtk2
    gtk3
    gtk4
    gvfs
    inetutils
    jetbrains-mono
    jq
    keepassxc
    killall
    kitty
    libsForQt5.okular
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugin-kvantum
    lsof
    lxappearance
    lxqt.lxqt-policykit
    mako
    mpv
    ncurses
    neofetch
    neovim
    netcat
    nettools
    networkmanagerapplet
    nfs-utils
    nil
    nixos-firewall-tool
    noto-fonts-color-emoji
    ntfs3g
    obconf
    onlyoffice-bin
    openssl.dev # dev needed for openssl headers
    pciutils
    phinger-cursors
    pkg-config
    pwvucontrol
    python312Full
    python312Packages.dbus-python
    python312Packages.ipython
    python312Packages.pip
    python312Packages.ipdb
    qalculate-gtk
    ripgrep
    signal-desktop
    sqlitebrowser
    tcpdump
    telegram-desktop
    themechanger
    tmux
    udevil
    udiskie
    unstable.nwg-look
    usbutils
    usermount
    unzip
    vim
    vulkan-tools
    wget
    wmctrl
    rofi
    wrapGAppsHook
    xcape
    xdg-desktop-portal-gtk
    xdg-desktop-portal
    xorg.libX11
    xorg.xinit
    unstable.zed-editor
    zip
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
