{ config, pkgs, unstable-pkgs, lib, ... }: 
let
    unfreePredicate = pkg: builtins.elem (lib.getName pkg) ["mongodb"];   
    pinnedMongodb = import (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/eb090f7b923b1226e8beb954ce7c8da99030f4a8.tar.gz";
    }) { config = { allowUnfreePredicate = unfreePredicate; }; };
in
{

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

  # for thumbnails
  services.tumbler.enable = true;

  qt.platformTheme = "lxqt";

  # kvantum theme
  xdg.portal.lxqt = {
    enable = true;
    styles =
      [ pkgs.libsForQt5.qtstyleplugin-kvantum pkgs.breeze-qt5 pkgs.qtcurve ];
  };

  # setup wireshark
  programs.wireshark.enable = true;

  # add tcpreplay group
  users.groups.tcpreplay = { };

  # enable polkit
  security.polkit.enable = true;

  # allow pam access for swaylock
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  # kwallet needed by python keyring
  security.pam.services.kdewallet.enableKwallet = true;

  # Audio for apps
  nixpkgs.config.pulseaudio = true;

  # Allow unfree packages
  # nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "webex"
      "mongodb"
      "mongodb-compass"
      "libsciter"
      "google-chrome"
      "vscode"
  ];

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
    webex
    pinnedMongodb.mongodb
    mongodb-compass
    libsciter
    google-chrome
    vscode
    ###
    xorg.xinit
    openbox
    openbox-menu
    obconf
    arandr
    tint2
    nitrogen
    vim
    greetd.tuigreet
    wget
    curlFull.dev # only dev has curl-config
    neovim
    git
    wayland
    xwayland
    xorg.libX11
    hyprland
    (pkgs.hyprland.override {
      enableXWayland = true;
      legacyRenderer = false;
      withSystemd = true;
    })
    kitty
    gnome.gnome-terminal
    gnome.dconf-editor
    gnome.gnome-keyring
    dconf
    pcmanfm
    jq
    unstable.wireshark
    unstable.tshark.dev
    libcap
    mako
    swayidle
    swaylock-effects
    waybar
    rofi
    wofi
    wlogout
    android-tools
    scrcpy
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-wlr
    themechanger
    openfortivpn
    gtk2
    gtk3
    gtk4
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    gobject-introspection
    pkg-config
    wrapGAppsHook
    desktop-file-utils
    glib
    glib.dev
    libglibutil
    glibc
    nextcloud-client
    gsettings-desktop-schemas
    killall
    helvum
    ripgrep
    openssl.dev # dev needed for openssl headers
    netcat
    ncurses
    cairo
    cairo.dev
    netcat
    bind
    okular
    dig
    du-dust
    bat
    nil
    eza
    helix
    lite-xl
    micro
    unstable.threema-desktop
    whatsapp-for-linux
    mpv
    ninja
    font-awesome
    meson
    gcc
    lsof
    usrsctp
    clang
    cpuid
    podman
    gdb
    gimp
    nextcloud-client
    gparted
    sqlitebrowser
    qalculate-gtk
    sqlite
    wlr-randr
    filezilla
    libreoffice
    libsForQt5.okular
    x2goclient
    rustdesk
    tmux
    nmap
    wayland-pipewire-idle-inhibit
    neofetch
    nettools
    grim
    slurp
    swappy
    xfce.thunar
    blueman
    pwvucontrol
    alsa-utils
    polkit_gnome
    lxqt.lxqt-policykit
    libsForQt5.kwallet
    python311Packages.dbus-python
    python311Full
    python311Packages.pip
    python311Packages.ipython
    allure
    brightnessctl
    bluez
    bluez-tools
    networkmanagerapplet
    gvfs
    exfat
    exfatprogs
    ntfs3g
    usermount
    udiskie
    autofs5
    udevil
    btop
    gnome.file-roller
    fish
    jetbrains-mono
    noto-fonts-color-emoji
    lxappearance
    xfce.xfce4-settings
    yazi
    feh
    wpaperd
    google-chrome
    firefox
    vscode
    ghidra-bin
    keepassxc
    wl-clipboard
    cliphist
    telegram-desktop
    signal-desktop
    threema-desktop
    tcpreplay
    tcpdump
    gnumake
    cmake
    cmakeCurses
    usbutils
    unstable.nwg-displays
    unstable.nwg-look
    gio-sharp
  ];
}
