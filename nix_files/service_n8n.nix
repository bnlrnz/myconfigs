{ config, lib, pkgs, ... }:
let
  unstable = import (builtins.fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz){ config.allowUnfree = true; };
  unstable_path = fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";  
  sops-nix = builtins.fetchTarball https://github.com/mic92/sops-nix/archive/master.tar.gz;
in
{
  imports = [
    "${sops-nix}/modules/sops"
    "${unstable_path}/nixos/modules/services/misc/n8n.nix"
  ];
 
  disabledModules = [ "services/misc/n8n.nix" ];

  allowUnfreePackages = [ "n8n" "n8n-task-runner-launcher" ];

  services.caddy.virtualHosts."n8n.b3lo.de".extraConfig = ''
    reverse_proxy http://localhost:5678
  '';
  
  nixpkgs.overlays = [  # add this
    (self: super: {
      n8n-task-runner-launcher = unstable.n8n-task-runner-launcher;
    })
  ];

  ##################
  # n8n
  ##################
  nixpkgs.config.packageOverrides = pkgs: {
    n8n = pkgs.n8n.overrideAttrs (oldAttrs: {
      env = (oldAttrs.env or {}) // {
        NODE_OPTIONS = "--max-old-space-size=4096";
      };
    });
  };

  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.secrets."n8n_task_runner/n8n_task_runner_token" = {
    sopsFile = ./secrets/nix-vps/n8n_task_runner_token.yaml;
  };

  services.n8n = {
    enable = true;
    openFirewall = true;
    taskRunners.enable = true;
    taskRunners.launcherPackage = pkgs.n8n-task-runner-launcher;
    environment.N8N_RUNNERS_AUTH_TOKEN_FILE = config.sops.secrets."n8n_task_runner/n8n_task_runner_token".path;
    environment.WEBHOOK_URL = "https://n8n.b3lo.de/";
    environment.N8N_HOST = "n8n.b3lo.de";
    # default port is 5678
    # due to out of memory error, build needed to run with this:
    environment.NODE_OPTIONS="--max-old-space-size=512"; # NODE_OPTIONS='--max-old-space-size=512'sudo nixos-rebuild switch --upgrade
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
