{ config, pkgs, unstable-pkgs, lib, ... }:
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

  environment.sessionVariables = rec {
    KUBECONFIG = "$HOME/.kube/config";
  };
}
