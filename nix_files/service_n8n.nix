{ config, lib, pkgs, ... }:
{
  allowUnfreePackages = [ "n8n" ];

  services.caddy.virtualHosts."n8n.b3lo.de".extraConfig = ''
    reverse_proxy http://localhost:5678
  '';

  ##################
  # n8n
  ##################
  services.n8n = {
    enable = true;
    openFirewall = true;
    environment.WEBHOOK_URL = "n8n.b3lo.de";
    # default port is 5678
    # due to out of memory error, build needed to run with this:
    # NODE_OPTIONS='--max-old-space-size=2000' sudo nixos-rebuild switch --upgrade
  };
  
  systemd.services.n8n = {
    path = with pkgs; [
      nix        # Provides nix-shell command
      python3    # Provides python3 interpreter
      bash       # Provides bash
      coreutils  # Provides standard Unix utilities
    ];
    
    # Optional: Add environment variables if needed
    environment = {
      NIX_PATH = "nixpkgs=${pkgs.path}";
    };
  };
}
