
{ config, lib, pkgs, ... }:
let
  unstableTarball = fetchTarball
    "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
in {
  # add unstable channel
  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball { config = config.nixpkgs.config; };
    };
  };

  # Disable the stable n8n module and import unstable
  disabledModules = [
    "services/misc/n8n.nix"
  ];

  imports = [
      "${unstableTarball}/nixos/modules/services/misc/n8n.nix"
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "n8n"
  ];

  services.caddy.virtualHosts."n8n.b3lo.de".extraConfig = ''
    reverse_proxy http://localhost:5678
  '';

  ##################
  # n8n
  ##################
  nixpkgs.overlays = [
    (final: prev: {
      n8n = pkgs.unstable.n8n;
    })
  ];

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