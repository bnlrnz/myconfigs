{ config, pkgs, unstable-pkgs, lib, ... }: 
let
    unfreePredicate = pkg: builtins.elem (lib.getName pkg) ["mongodb"];   
    pinnedMongodb = import (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/eb090f7b923b1226e8beb954ce7c8da99030f4a8.tar.gz";
    }) { config = { allowUnfreePredicate = unfreePredicate; }; };
in
{
  # linux kernel package
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix.gc.automatic = true;

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
  xdg.portal.lxqt = {
    enable = true;
  #  styles =
  #    [ pkgs.libsForQt5.qtstyleplugin-kvantum pkgs.breeze-qt5 pkgs.qtcurve ];
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
      "steam"
      "steam-original"
      "steam-run"
      "burpsuite"
      "corefonts"
      "vista-fonts"
  ];

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      nerdfonts
      source-han-sans
      open-sans
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
    webex
    pinnedMongodb.mongodb
    mongodb-compass
    libsciter
    google-chrome
    vscode
    ###
    allure
    alsa-utils
    android-tools
    arandr
    autofs5
    bat
    bind
    binwalk
    bless
    blueman
    bluez
    bluez-tools
    brightnessctl
    btop
    btrfs-progs
    burpsuite
    cairo
    cairo.dev
    clang
    cliphist
    cmake
    cmakeCurses
    cpuid
    curlFull.dev # only dev has curl-config
    dconf
    desktop-file-utils
    dig
    du-dust
    dracula-theme
    dracula-icon-theme
    exfat
    exfatprogs
    eza
    feh
    feroxbuster
    filezilla
    firefox
    fish
    fzf
    font-awesome
    gcc
    gdb
    gef
    ghidra-bin
    gimp
    gio-sharp
    git
    glib
    glib.dev
    glibc
    gnome.dconf-editor
    gnome.file-roller
    gnome.gnome-keyring
    gnome.gnome-terminal
    gnumake
    gobject-introspection
    gobuster
    google-chrome
    gparted
    grim
    gsettings-desktop-schemas
    gtk2
    gtk3
    gtk4
    guvcview
    gvfs
    hashcat
    inetutils
    jetbrains-mono
    jq
    keepassxc
    killall
    kitty
    kora-icon-theme
    libcap
    libglibutil
    libreoffice
    libsForQt5.kwallet
    libsForQt5.okular
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugin-kvantum
    lsof
    lxappearance
    lxqt.lxqt-policykit
    mako
    meson
    mpv
    ncurses
    neofetch
    neovim
    netcat
    nettools
    networkmanagerapplet
    nextcloud-client
    nil
    ninja
    nitrogen
    nixos-firewall-tool
    nmap
    noto-fonts-color-emoji
    ntfs3g
    obconf
    okular
    onlyoffice-bin
    openbox
    openbox-menu
    openssl.dev # dev needed for openssl headers
    padbuster
    patchelf
    phinger-cursors
    pkg-config
    podman
    polkit_gnome
    protontricks
    protonup # update manager for proton
    pwndbg
    pwninit
    pwntools
    pwvucontrol
    python311Full
    python311Packages.dbus-python
    python311Packages.ipython
    python311Packages.pip
    python311Packages.ipdb
    qalculate-gtk
    ripgrep
    rofi
    #rustdesk
    scrcpy
    signal-desktop
    slurp
    sqlite
    sqlitebrowser
    swappy
    swayidle
    swaylock-effects
    tcpdump
    tcpreplay
    telegram-desktop
    themechanger
    tint2
    tmux
    udevil
    udiskie
    unstable.hyprland
    (pkgs.unstable.hyprland.override {
      enableXWayland = true;
      legacyRenderer = false;
      withSystemd = true;
    })
    unstable.nwg-displays
    unstable.nwg-look
    #unstable.threema-desktop # currently broken 10/07/2024
    unstable.tshark.dev
    unstable.wireshark
    usbutils
    usermount
    usrsctp
    vim
    vscode
    vulkan-tools
    waybar
    wayland
    wayland-pipewire-idle-inhibit
    wget
    whatsapp-for-linux
    wl-clipboard
    wlogout
    unstable.wlr-layout-ui
    wlr-randr
    wofi
    wpaperd
    wrapGAppsHook
    x2goclient
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
    xdg-desktop-portal
    xfce.thunar
    xfce.xfce4-settings
    xorg.libX11
    xorg.xinit
    xwayland
    yazi # terminal file browser
    unstable.zed-editor
  ];
}
