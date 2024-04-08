{ config, pkgs, unstable-pkgs, lib, ... }: {
  
  services.xserver.enable = true;
  services.xserver.windowManager.openbox.enable = true;
  # services.xserver.displayManager.sddm.enable = true;
  # start gdm display manager in backgroud
  #services.xserver.displayManager.gdm = {
  #  enable = true;
  #  wayland = true;
  #  autoSuspend = true;
  #};

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
}
