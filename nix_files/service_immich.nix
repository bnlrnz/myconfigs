
{ config, lib, pkgs, ... }:
{
  services.caddy.virtualHosts."img.b3lo.de".extraConfig = ''
      request_body {
        max_size 500MB
      }
      reverse_proxy http://localhost:2283
    '';

  ###############
  # Immich
  ###############
  services.immich = {
    enable = true;
    port = 2283;
    host = "localhost";
    accelerationDevices = null;
    settings.server.externalDomain = "https://img.b3lo.de";
  };

  users.users.immich.extraGroups = [ "video" "render" ];

  environment.systemPackages = with pkgs; [
    immich-go
  ];
}