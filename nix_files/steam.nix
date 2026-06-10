{ pkgs, ... }: 
{
  # steam only for home pc
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;
  programs.gamescope = {
    enable = true;
    capSysNice = false; # TEMPORARY?
    env = {
      XKB_DEFAULT_LAYOUT = "de";
    };
  };

  environment.systemPackages = with pkgs; [
    mangohud
    goverlay
    protonup-qt
    #    lutris
    heroic
    winetricks
    protontricks
    wineWow64Packages.waylandFull
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = 
      "\${HOME}/.steam/root/compatibilitytools.d";
  };


}
