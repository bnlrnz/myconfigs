# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration_nix-vps.nix
      ./wed_web.nix
      ./nextcloud-pass.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # linux kernel package
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  # hardening
  #environment.memoryAllocator.provider = "scudo"; # nextcloud does not like this
  #environment.variables.SCUDO_OPTIONS = "ZeroContents=1";

  security.apparmor = {
    enable = true;
    killUnconfinedConfinables = true;
  };

  boot.kernelParams = [
    # Don't merge slabs
    "slab_nomerge"

    # Overwrite free'd pages
    "page_poison=1"

    # Enable page allocator randomization
    "page_alloc.shuffle=1"

    # Disable debugfs
    "debugfs=off"
  ];

  boot.blacklistedKernelModules = [
    # Obscure network protocols
    "ax25"
    "netrom"
    "rose"

    # Old or rare or insufficiently audited filesystems
    "adfs"
    "affs"
    "bfs"
    "befs"
    "cramfs"
    "efs"
    "erofs"
    "exofs"
    "freevxfs"
    "f2fs"
    "hfs"
    "hpfs"
    "jfs"
    "minix"
    "nilfs2"
    "ntfs"
    "omfs"
    "qnx4"
    "qnx6"
    "sysv"
    "ufs"
  ];

  # Hide kptrs even for processes with CAP_SYSLOG
  boot.kernel.sysctl."kernel.kptr_restrict" = lib.mkOverride 500 2;

  # Disable bpf() JIT (to eliminate spray attacks)
  boot.kernel.sysctl."net.core.bpf_jit_enable" = false;

  # Disable ftrace debugging
  boot.kernel.sysctl."kernel.ftrace_enabled" = false;

  # Enable strict reverse path filtering (that is, do not attempt to route
  # packets that "obviously" do not belong to the iface's network; dropped
  # packets are logged as martians).
  boot.kernel.sysctl."net.ipv4.conf.all.log_martians" = true;
  boot.kernel.sysctl."net.ipv4.conf.all.rp_filter" = "1";
  boot.kernel.sysctl."net.ipv4.conf.default.log_martians" = true;
  boot.kernel.sysctl."net.ipv4.conf.default.rp_filter" = "1";

  # Ignore broadcast ICMP (mitigate SMURF)
  boot.kernel.sysctl."net.ipv4.icmp_echo_ignore_broadcasts" = true;

  # Ignore incoming ICMP redirects (note: default is needed to ensure that the
  # setting is applied to interfaces added after the sysctls are set)
  boot.kernel.sysctl."net.ipv4.conf.all.accept_redirects" = false;
  boot.kernel.sysctl."net.ipv4.conf.all.secure_redirects" = false;
  boot.kernel.sysctl."net.ipv4.conf.default.accept_redirects" = false;
  boot.kernel.sysctl."net.ipv4.conf.default.secure_redirects" = false;
  boot.kernel.sysctl."net.ipv6.conf.all.accept_redirects" = false;
  boot.kernel.sysctl."net.ipv6.conf.default.accept_redirects" = false;

  # Ignore outgoing ICMP redirects (this is ipv4 only)
  boot.kernel.sysctl."net.ipv4.conf.all.send_redirects" = false;
  boot.kernel.sysctl."net.ipv4.conf.default.send_redirects" = false;

  # garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
  };

# Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
#boot.loader.grub.efiSupport = true;
#boot.loader.grub.efiInstallAsRemovable = true;
# boot.loader.efi.efiSysMountPoint = "/boot/efi";
# Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

    networking.hostName = "nix-vps"; # Define your hostname.
# Pick only one of the below networking options.
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

# Set your time zone.
    time.timeZone = "Europe/Berlin";

# Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkForce "us";
  };

  programs.fish.enable = true;

# Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ben = {
    isNormalUser = true;
    extraGroups = [ "wheel" "nextcloud" "caddy" ]; # Enable ‘sudo’ for the user.
      shell = pkgs.fish;
  };

  users.defaultUserShell = pkgs.fish;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "corefonts"
  ];

# List packages installed in system profile. To search, run:
# $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      git
      neovim
      curl
      python312
      python312Packages.flask
      ripgrep
      bat
      eza
      du-dust
      ffmpeg
      exiftool
      htop
      jq
      wget
      yazi
  ];

# Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false; # public key only
    };
  };

  services.caddy = {
    enable = true;
    virtualHosts."bnlrnz.de".extraConfig = ''
      header / {
      	Strict-Transport-Security "max-age=31536000;"
      	  X-XSS-Protection "1; mode=block"
      	  X-Content-Type-Options "nosniff"
      	  X-Frame-Options "DENY"
      }
      encode gzip
      file_server
      root * /var/www/MimaSim/web
      '';
    virtualHosts."lorenzjoerg.de".extraConfig = ''
      header / {
      	Strict-Transport-Security "max-age=31536000;"
      	  X-XSS-Protection "1; mode=block"
      	  X-Content-Type-Options "nosniff"
      	  X-Frame-Options "DENY"
      }
      encode gzip
      file_server
      root * /var/www/grav
      php_fastcgi unix/${config.services.phpfpm.pools.caddy.socket}
    '';
    virtualHosts."wedding.bnlrnz.de".extraConfig = ''
      header / {
      	Strict-Transport-Security "max-age=31536000;"
      	  X-XSS-Protection "1; mode=block"
      	  X-Content-Type-Options "nosniff"
      	  X-Frame-Options "DENY"
      }
      reverse_proxy unix//var/www/wed_web/wed_web.sock
    '';
    virtualHosts."cloud.bnlrnz.de".extraConfig = ''
        header / {
      	  Strict-Transport-Security "max-age=31536000;"
      	  X-XSS-Protection "1; mode=block"
      	  X-Content-Type-Options "nosniff"
      	  X-Frame-Options "DENY"
        }
        redir /.well-known/carddav /remote.php/dav/ 301
        redir /.well-known/caldav /remote.php/dav/ 301
        reverse_proxy http://127.0.0.1:8080
    '';
    virtualHosts."oo.bnlrnz.de".extraConfig = ''
     header / {
      	Strict-Transport-Security "max-age=31536000;"
      	  X-XSS-Protection "1; mode=block"
      	  X-Content-Type-Options "nosniff"
      	  X-Frame-Options "DENY"
     }
     reverse_proxy http://127.0.0.1:8888 {
       # Required to circumvent bug of Onlyoffice loading mixed non-https content
        header_up X-Forwarded-Proto https
        header_up X-Forwarded-Host oo.bnlrnz.de
        header_up X-Forwarded-Porto 443
    
     }
    '';
  }; 

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 80 443];

# phpfpm pool
  services.phpfpm.pools.caddy = {
    user = config.services.caddy.user;
    group = config.services.caddy.group;
    settings = {
      "listen.owner" = config.services.caddy.user;
      "pm" = "dynamic";
      "pm.max_children" = 32;
      "pm.max_requests" = 500;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 2;
      "pm.max_spare_servers" = 5;
      "php_admin_value[error_log]" = "stderr";
      "php_admin_flag[log_errors]" = true;
      "catch_workers_output" = true;
    };
    phpEnv."PATH" = lib.makeBinPath [ pkgs.php ];
  };

  services.nextcloud = {
    enable = true;
    config.adminpassFile = "/etc/nextcloud-admin-pass";
    package = pkgs.nextcloud30;
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) onlyoffice;
    };
    extraAppsEnable = true;
    appstoreEnable = true;
    hostName = "localhost_nextcloud";
    https = true;
    configureRedis = true;
    database.createLocally = true;
    maxUploadSize = "20G";
    settings.trusted_proxies = [ "127.0.0.1" ];
    settings.trusted_domains = [ "cloud.bnlrnz.de" "127.0.0.1" "149.102.140.151" ];
    settings.default_phone_region = "DE";
    phpOptions = {
      "opcache.interned_strings_buffer" = "10";
    };
  };

  services.nginx.virtualHosts."localhost_nextcloud".listen = [ { addr = "127.0.0.1"; port = 8080; } ];

  services.onlyoffice = {
    enable = true;
    hostname = "localhost_onlyoffice";
    jwtSecretFile = "/etc/nextcloud-admin-pass";
    port = 8888;
  };

  services.nginx.virtualHosts."localhost_onlyoffice" = {
    listen = [ { addr = "127.0.0.1"; port = 8081; } ];
  };

# Copy the NixOS configuration file and link it from the resulting system
# (/run/current-system/configuration.nix). This is useful in case you
# accidentally delete configuration.nix.
# system.copySystemConfiguration = true;

# This option defines the first version of NixOS you have installed on this particular machine,
# and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
#
# Most users should NEVER change this value after the initial install, for any reason,
# even if you've upgraded your system to a new NixOS release.
#
# This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
# so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
# to actually do that.
#
# This value being lower than the current NixOS release does NOT mean your system is
# out of date, out of support, or vulnerable.
#
# Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
# and migrated your data accordingly.
#
# For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}

