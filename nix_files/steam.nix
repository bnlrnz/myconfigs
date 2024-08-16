{ pkgs, ... }: 
{
  # steam only for home pc
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    mangohud
    goverlay
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = 
      "\${HOME}/.steam/root/compatibilitytools.d";
  };
}
