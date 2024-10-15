{ config, pkgs, unstable-pkgs, lib, ... }: {
  # allow nix flakes  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # let this run for now
  # sometimes we need this e.g. for webex
  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;
    windowManager.openbox.enable = true;
  };

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

  # nfs mounts
  services.rpcbind.enable = true;
 
#  fileSystems."/mnt/org-sz31" = {
#    device = "fs1.temislab.de:/vsanfs/org-sz31";
#    fsType = "nfs";
#    options = ["x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" "hard" "nfsvers=4.1" "sec=sys" "rw" "intr" "noexec" "nosuid" "timeo=20"];
#  };

  fileSystems."/mnt/user-belo" = {
    device = "fs1.temislab.de:/vsanfs/user-belo";
    fsType = "nfs";
    options = ["x-systemd.automount" "noauto" "x-systemd.idle-timeout=600"];
  };
  fileSystems."/mnt/svc-specbutler" = {
    device = "fs1.temislab.de:/vsanfs/svc-specbutler";
    fsType = "nfs";
    options = ["x-systemd.automount" "noauto" "x-systemd.idle-timeout=600"];
  };
  fileSystems."/mnt/svc-scasbrowser" = {
    device = "fs1.temislab.de:/vsanfs/svc-scasbrowser";
    fsType = "nfs";
    options = ["x-systemd.automount" "noauto" "x-systemd.idle-timeout=600"];
  };

  services.ollama = {
  	enable = true;
	acceleration = "rocm";
  };
}
