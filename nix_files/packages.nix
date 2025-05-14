{ config, pkgs, unstable-pkgs, lib, ... }: 
{
  # linux kernel package
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # automatic store optimization
  nix.optimise.automatic = true;

  # garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # enable fish
  programs.fish.enable = true;
  # rebuilds can be terribly slow because of fish rebuilding caches
  # documentation.man.generateCaches = false;

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

  # setup wireshark - setcap and so on
  programs.wireshark.enable = true;
  
  # this should work, but does not...
  # programs.tcpdump.enable = true;
  # lets do it by hand until fixed:
  security.wrappers.tcpdump = {
    owner = "root";
    group = "pcap";
    capabilities = "cap_net_raw+p";
    permissions = "u+rx,g+x";
    source = lib.getExe pkgs.tcpdump;
  };
  users.groups.pcap = { };

  # add tcpreplay group
  users.groups.tcpreplay = { };

  # enable polkit
  security.polkit.enable = true;

  # idle and lock
  # allow pam access for swaylock
  programs.hyprlock.enable = true; # this is a handy trick: config.networking.hostName == "tp-belo";

  # kwallet needed by python keyring
  security.pam.services.kdewallet.enableKwallet = true;

  # Audio for apps
  nixpkgs.config.pulseaudio = true;

  # Allow unfree packages
  # nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "webex"
      "burpsuite"
      "mongodb-ce"
      "mongodb-compass"
      "libsciter"
      #"google-chrome"
      "vscode"
      "corefonts"
      "vista-fonts"
      "steam"
      "steam-original"
      "steam-run"
      "steam-unwrapped"
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
    webex
    mongodb-ce
    mongodb-compass
    libsciter
    #google-chrome
    vscode
    ###
    acpi
    allure
    alsa-utils
    android-tools
    arandr
    autofs5
    bat
    bind
    binwalk
    #bless not maintained anymore -> try Okteta
    blueman
    bluez
    bluez-tools
    brightnessctl
    btop
    btrfs-progs
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
    filezilla
    firefox
    fish
    fzf
    font-awesome
    gcc
    gdb
    ghex
    gimp
    gio-sharp
    git
    glib.dev
    glibc
    dconf-editor
    gnumake
    gobject-introspection
    gparted
    grim
    gsettings-desktop-schemas
    gtk2
    gtk3
    gtk4
    guvcview
    gvfs
    inetutils
    jetbrains-mono
    jq
    keepassxc
    killall
    kitty
    kora-icon-theme
    libcap
    libglibutil
    libnotify
    libreoffice
    librewolf-bin
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
    nfs-utils
    nil
    ninja
    nitrogen
    nixos-firewall-tool
    nmap
    noto-fonts-color-emoji
    ntfs3g
    obconf
    okular
    okteta
    onlyoffice-bin
    openssl.dev # dev needed for openssl headers
    patchelf
    pciutils
    phinger-cursors
    pkg-config
    polkit_gnome
    protontricks
    protonup # update manager for proton
    pwvucontrol
    python312Full
    python312Packages.dbus-python
    python312Packages.ipython
    python312Packages.pip
    python312Packages.ipdb
    qalculate-gtk
    ripgrep
    rofi
    rustdesk-flutter
    scrcpy
    signal-desktop
    slurp
    sqlite
    sqlitebrowser
    swappy
    tcpdump
    tcpreplay
    telegram-desktop
    themechanger
    tmux
    udevil
    udiskie
    hyprland-monitor-attached
    hyprshot
    hyprpolkitagent
    unstable.nwg-look
    unstable.threema-desktop # currently broken 10/07/2024
    unstable.tshark.dev
    wireshark
    usbutils
    usermount
    usrsctp
    unzip
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
    xfce.xfce4-settings
    xorg.libX11
    xorg.xinit
    xwayland
    yazi # terminal file browser
    unstable.zed-editor
    zip
  ];
}
