{ config, pkgs, unstable-pkgs, lib, ... }:
let
  kubectl-fzf = pkgs.buildGoModule rec {
    pname = "kubectl-fzf";
    version = "main"; # Replace with the latest version if needed

    src = pkgs.fetchgit {
      url = "https://github.com/bonnefoa/kubectl-fzf.git";
      rev = "main";
      sha256 = "sha256-NPCsTJYgiBA1xoZq6TH/hCJYOFdoj6Exzb4D9pLRqZQ="; # Replace with actual SHA256
    };

    vendorHash = "sha256-dOEYHMHHaksy7K1PgfFrSzRcucOgnHjZFpl+/2A1Zzs=";  # Let Nix fetch dependencies

    subPackages = [
      "cmd/kubectl-fzf-completion"
      "cmd/kubectl-fzf-server"
    ];
  };
in
{
  networking.firewall.allowedTCPPorts = [
    6443 # k3s
  ];

  services.k3s.enable = true;
  services.k3s.role = "server";
  services.k3s.extraFlags = toString [
    # "--debug" # Optionally add additional args to k3s
  ];

  environment.systemPackages = with pkgs; [
    kubernetes-helm
    fzf
    kubectl-fzf
  ];

  users.groups.kubeusers = {};

  systemd.services.copy-kubeconfig = {
    description = "Copy k3s kubeconfig for allowed users";
    after = [ "k3s.service" ]; # Run after k3s starts
    before = [ "multi-user.target" ]; # Ensure it's done early
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "copy-kubeconfig" ''
        PATH=${pkgs.coreutils}/bin:${pkgs.glibc.bin}/bin

        for user in $(${pkgs.getent}/bin/getent group kubeusers | ${pkgs.coreutils}/bin/cut -d: -f4 | ${pkgs.coreutils}/bin/tr ',' ' '); do
          home=$(eval echo ~$user)
          if [ -n "$home" ]; then
            mkdir -p "$home/.kube"
            cp /etc/rancher/k3s/k3s.yaml "$home/.kube/config"
            chown "$user:kubeusers" "$home/.kube/config"
            chmod 600 "$home/.kube/config"
          fi
        done
      '';
    };
  };

  environment.sessionVariables = {
    KUBECONFIG = "$HOME/.kube/config";
  };
}
