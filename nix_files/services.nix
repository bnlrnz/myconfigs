{ config, pkgs, lib, ... }:
let
  unstableTarball = fetchTarball
    "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
in
{
  # add unstable channel
  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball { config = config.nixpkgs.config; };
    };
  };

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
    package = pkgs.unstable.hyprland;
    xwayland.enable = true;
  };

  # FIX: temporary for hyprland 0.56 and firefox 153.0
	environment.sessionVariables.XDG_DATA_DIRS = [
		"${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
		"${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
	];

  # enable pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

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

  # enable blueman service
  services.blueman.enable = true;

  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
      Experimental = true;
    };
  };

  # enable fwupd -> fwupdmgr
  services.fwupd.enable = true;

  # upower service for laptops/battery
  services.upower.enable = true;

  # disable speechd and orca
  services.speechd.enable = false;
  services.orca.enable = false;

  # docker
  virtualisation.docker.enable = true;

  #services.ollama = {
  # 	enable = true;
	#  acceleration = "rocm";
  #};
}
