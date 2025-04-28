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
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
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
  boot.loader.systemd-boot.configurationLimit = 5;

  # automatic store optimization
  nix.optimise.automatic = true;

  # garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

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
  programs.captive-browser.interface = "wlp0s20f3";

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
    extraGroups = [ "networkmanager" "wheel" "audio" "wireshark" "wireguard" ];
    packages = with pkgs; [ ];
    shell = pkgs.fish;
  };
  users.defaultUserShell = pkgs.fish;
  
  # allow nix flakes  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.libinput.enable = true;
  
  # gnome keyring
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  # setup hyprland
  programs.xwayland.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # idle and lock
  # allow pam access for swaylock
  services.hypridle.enable = true;
  programs.hyprlock.enable = true; # this is a handy trick: config.networking.hostName == "tp-belo";

  # kwallet needed by python keyring
  security.pam.services.kdewallet.enableKwallet = true;

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

  # enable user polkit service
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

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

  # kvantum theme
  xdg.portal.lxqt.enable = true;
  
  # enable polkit
  security.polkit.enable = true;

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
      nerdfonts
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
    grim
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
    kora-icon-theme
    libsForQt5.kwallet
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
    nitrogen
    nixos-firewall-tool
    nmap
    noto-fonts-color-emoji
    ntfs3g
    obconf
    onlyoffice-bin
    openssl.dev # dev needed for openssl headers
    pciutils
    phinger-cursors
    pkg-config
    polkit_gnome
    pwvucontrol
    python312Full
    python312Packages.dbus-python
    python312Packages.ipython
    python312Packages.pip
    python312Packages.ipdb
    qalculate-gtk
    ripgrep
    signal-desktop
    slurp
    sqlitebrowser
    swappy
    tcpdump
    telegram-desktop
    themechanger
    tmux
    udevil
    udiskie
    hyprland-monitor-attached
    hyprshot
    hyprpolkitagent
    unstable.nwg-look
    usbutils
    usermount
    unzip
    vim
    vscode
    vulkan-tools
    waybar
    wayland
    wayland-pipewire-idle-inhibit
    wget
    wl-clipboard
    wlogout
    unstable.wlr-layout-ui
    wlr-randr
    wofi
    wpaperd
    wrapGAppsHook
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
    xdg-desktop-portal
    xfce.xfce4-settings
    xorg.libX11
    xorg.xinit
    xwayland
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
