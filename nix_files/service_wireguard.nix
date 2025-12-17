
{ config, lib, pkgs, ... }:
let
  sops-nix = builtins.fetchTarball https://github.com/mic92/sops-nix/archive/master.tar.gz;
in{
  import = [
        "${sops-nix}/modules/sops"
  ]

  ################
  # wireguard
  ################
  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.age.keyFile = "/home/ben/.config/sops/age/keys.txt";
  sops.age.generateKey = true;
  sops.secrets."wireguard/vps_private" = { };

  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ 
        "10.10.11.200/24"
      ];
      listenPort = 51820; 
      privateKeyFile = config.sops.secrets."wireguard/vps_private".path;
      peers = [
        { # raspi
          publicKey = "/jB466c9UawpjHvoJzvDpblnXcgCImlEC+NMYw5pHiE=";
          allowedIPs = [ "10.10.11.201/32" "10.10.10.0/24" ];
          persistentKeepalive = 25;
        }
        { # pixel ben
          publicKey = "eBcMo1BtMV4vIfuDZ5vs9KLPtrGyHB/6vpEcKr2lq0I=";
          allowedIPs = [ "10.10.11.202/32" ];
          persistentKeepalive = 25;
        }
        { # macbookair 
          publicKey = "3im8Bk8aXlevlFmniDrXpYPAbf7eVmR6PjPLM2cJiDM=";
          allowedIPs = [ "10.10.11.203/32" ];
          persistentKeepalive = 25;
        }

      ];
    };
  };
 
  networking.firewall.allowedUDPPorts = [ 51820 ];

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  networking.firewall.trustedInterfaces = [ "wg0" ];
  networking.interfaces.wg0.ipv4.routes = [
    { address = "10.10.10.0"; prefixLength = 24; via = "10.10.11.201"; }
  ];
  networking.firewall.extraCommands = ''
    # Allow forwarding between WireGuard peers
    iptables -A FORWARD -i wg0 -o wg0 -j ACCEPT
    iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
  '';
}