# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
let
  sops-nix = builtins.fetchTarball https://github.com/mic92/sops-nix/archive/master.tar.gz;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      "${sops-nix}/modules/sops"
    ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  networking = {
  	hostName = "nix-pi"; # Define your hostname.
	extraHosts = ''
		10.10.10.25 nix
	'';
	# Pick only one of the below networking options.
  	wireless.enable = false;  # Enables wireless support via wpa_supplicant.
  	#networkmanager.enable = true;  # Easiest to use and most distros use this by default.
	
	interfaces.end0 = {
	ipv4.addresses = [{
			address = "10.10.10.74";
			prefixLength = 24;
		}];
	};
	defaultGateway = {
		address = "10.10.10.1";
		interface = "end0";
	};

	# Open ports in the firewall.
  	firewall = {
		enable = true;
		allowedTCPPorts = [
			53	# adguard dns
			80	# adguard
			3000	# adguard
			8123 	# home assistant
		];
		allowedUDPPorts = [ 
			53	# adguard dns
		];
	};
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
   console = {
     font = "Lat2-Terminus16";
     keyMap = "de";
     # useXkbConfig = true; # use xkb.options in tty.
   };

  # Configure keymap in X11
  # services.xserver.xkb.layout = "de";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.ben = {
     isNormalUser = true;
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
     shell = pkgs.fish;
   };

  users.defaultUserShell = pkgs.fish; 
   
  programs.fish.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
     	vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
	wget
	neovim
	fish
	git
	eza
	dust
	bat
#	ripgrep
	zellij
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # adguard home setup
  services.adguardhome = {
    enable = true;
    openFirewall = true;
    allowDHCP = true;
  };

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

  services.home-assistant = {
    enable = true;
    extraComponents = [
      # Components required to complete the onboarding
      "esphome"
      "met"
      "radio_browser"
      "homematicip_cloud"
      "roborock"
    ];
    #customComponents = [
#	pkgs.home-assistant-component-tests.homematicip_cloud
#    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = {};
    };
  };

  nix.distributedBuilds = true;
  nix.buildMachines = [
    {
      hostName = "builder@nix";
      systems = [ "x86_64-linux" "aarch64-linux" ];
      sshKey = "/home/ben/.ssh/id_builder";
      maxJobs = 4;
      speedFactor = 4;
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    }
  ];

  programs.ssh.extraConfig = ''
Host nix
  Port 22
  User builder
  IdentitiesOnly yes
  IdentityFile /home/ben/.ssh/id_builder
  '';

  # wireguard
  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.age.keyFile = "/home/ben/.config/sops/age/keys.txt";
  sops.age.generateKey = true;
  sops.secrets."wireguard/pi_private" = { };

  networking.wg-quick.interfaces.wg0 = {
    address = [ "10.10.11.201/24" ];
    privateKeyFile = config.sops.secrets."wireguard/pi_private".path;
    peers = [
      {
      	# vps
        publicKey = "fzWcwGSJfsJYW6Xx/gVKB28B57Wdg9sSYrwlqV+D/F4=";
        endpoint = "b3lo.de:51820";
        allowedIPs = [ "10.10.11.200/32" ];
        persistentKeepalive = 25;
      }
    ];
  };

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
 
  # Enable IP forwarding and NAT
  networking.nat.enable = true;
  networking.nat.internalInterfaces = [ "wg0" ];
  networking.nat.externalInterface = "end0"; # adjust to your Pi's external interface

  networking.firewall.checkReversePath = false;
  networking.firewall.extraCommands = ''
    iptables -A FORWARD -i wg0 -o end0 -j ACCEPT
    iptables -A FORWARD -i end0 -o wg0 -j ACCEPT
    iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
    iptables -A FORWARD -i wg0 -p icmp -j ACCEPT
  '';

  # Copy the NixOS configuration file and link it from the resulting system
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
  system.stateVersion = "24.11"; # Did you read the comment?

}

