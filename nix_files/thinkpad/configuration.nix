# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, unstable-pkgs, lib, ... }:

let
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  
  # add unstable channel
  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Limit generations
  boot.loader.systemd-boot.configurationLimit = 20;

  boot.initrd.luks.devices."luks-49f4f24c-6e57-48de-8f8c-ed9d206907b4".device = "/dev/disk/by-uuid/49f4f24c-6e57-48de-8f8c-ed9d206907b4";
  networking.hostName = "tp-belo"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.nameservers = ["1.1.1.1" "10.50.1.1" "9.9.9.9" "8.8.8.8"];

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

  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "de";
 
  # laptop power management
  powerManagement.enable = true;
  services.thermald.enable = true;
  services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 50;

       #Optional helps save long term battery health
       #START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
       STOP_CHARGE_THRESH_BAT0 = 95; # 80 and above it stops charging

      };
  };

  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
    autoSuspend = true;
  };

  programs.xwayland.enable = true;
  programs.hyprland = {
  	enable = true;
	  xwayland.enable = true;
  };
  
  services.getty.autologinUser = "belo";

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
  services.tumbler.enable = true;

  qt.platformTheme = "lxqt";
  
  #xdg.portal.config.common.default = "*";
  xdg.portal.lxqt = {
    enable = true;
    styles = [
        pkgs.libsForQt5.qtstyleplugin-kvantum
        pkgs.breeze-qt5
        pkgs.qtcurve
    ];
  };

  # setup wireshark
  programs.wireshark.enable = true;
  
  # enable pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    #pulse.enable = true;
    wireplumber.enable = true;
  };

  # automount usb
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true; 

  # allow users to build packages
  nix.settings.allowed-users = ["@wheel" "belo"];
  
  # add tcpreplay group
  users.groups.tcpreplay = {};

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.belo = {
    isNormalUser = true;
    description = "belo";
    extraGroups = [ "networkmanager" "wheel" "audio" "wireshark" "tcpreplay"];
    packages = with pkgs; [];
    shell = pkgs.fish;
  };
  users.defaultUserShell = pkgs.fish;

  security.polkit.enable = true;
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  # kwallet needed by python keyring
  security.pam.services.kdewallet.enableKwallet = true;

  systemd = {
  user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  # enable blueman service
  services.blueman.enable = true;
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Audio for apps
  nixpkgs.config.pulseaudio = true;

  environment.systemPackages = with pkgs; [
   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
   wget
   curlFull.dev # only dev has curl-config
   neovim
   git
   wayland
   xwayland
   xorg.libX11
   unstable.hyprland
   (pkgs.unstable.hyprland.override { 
  	enableXWayland = true;
  	legacyRenderer = false;
  	withSystemd = true;
   })
   kitty
   gnome.gnome-terminal
   gnome.dconf-editor
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
   wofi
   wlogout
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
   catppuccin
   catppuccin-kvantum
   catppuccin-cursors
   catppuccin-gtk
   (catppuccin-gtk.override {
    accents = [ "teal" ]; # You can specify multiple accents here to output multiple themes
    size = "compact";
    tweaks = [ "rimless" "black" ]; # You can also specify multiple tweaks here
    variant = "macchiato";
   })
   killall
   #toybox
   #pavucontrol
   helvum
   ripgrep
   openssl.dev # dev needed for openssl headers
   netcat
   ncurses
   cairo
   cairo.dev
   netcat
   bind
   dig
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
   mongodb
   mongodb-compass
   sqlite
   wlr-randr
   filezilla
   libreoffice
   libsForQt5.okular
   x2goclient
   rustdesk
   tmux
   nmap
   neofetch
   nettools
   grim
   slurp
   swappy
   xfce.thunar
   blueman
   #pamixer
   pwvucontrol
   alsa-utils
   polkit_gnome
   lxqt.lxqt-policykit
   libsForQt5.kwallet
   python311Packages.dbus-python
   python311Full
   python311Packages.pip
   python311Packages.ipython
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
   #sublime4
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
   gio-sharp
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
    ];
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" "Source Han Serif" ];
      sansSerif = [ "Open Sans" "Source Han Sans" ];
      emoji = [ "Noto Color Emoji" ];
    };
    enableDefaultPackages = true;
  };

  #hardware.pulseaudio = {
  #  enable = true;
  #  package = pkgs.pulseaudioFull;
  #};

  hardware.bluetooth.settings = {
    General = {
	    Enable = "Source,Sink,Media,Socket";
	    Experimental = true;
     };
  };

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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.resolvconf.enable = false;
  networking.firewall = {
    enable = false;
    checkReversePath = false;
    allowedUDPPorts = [4431]; # openfortivpn -> 4431
  };
  
  networking.networkmanager = {
    extraConfig = "[vpn]\nform:main:username-flags=0\n[vpn-secrets]\ncertificate:91.137.126.52:4431=pin-sha256:uqrIE1lFD0L4iSDjvTlcnPzZ0VJzrZ2jeffMbi4a5UQ=\n";
  };

  #networking.openconnect.interfaces.temisvpn0 = {
  #  gateway = "91.137.126.52:4431";
  #  protocol = "fortinet";
  #  user = "BSI_LorenzB";
  #  extraOptions = {
  #    passwd-on-stdin = true;
  #    servercert="pin-sha256:uqrIE1lFD0L4iSDjvTlcnPzZ0VJzrZ2jeffMbi4a5UQ=";
  #  };
  #};

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
