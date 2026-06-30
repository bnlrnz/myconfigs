
{ config, lib, pkgs, ... }:
let
  sops-nix = builtins.fetchTarball https://github.com/mic92/sops-nix/archive/master.tar.gz;
  wgPort = 51820;
  wsPort = 51821;        # localhost only, behind caddy
  extIf = "ens18";
  tunnelDomain = "tunnel.b3lo.de";
in{
  imports = [
    "${sops-nix}/modules/sops"
  ];

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
      listenPort = wgPort; 
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
        {
          publicKey = "ck2woPX7nSSr/gwnc3jQFNw0M1DrxLEGcwnUdW1gBEQ=";
          allowedIPs = [ "10.10.11.204/32" ];
          persistentKeepalive = 25;
        }
      ];
    };
  };
 
  networking.firewall.allowedUDPPorts = [ wgPort ];

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  # Enable NAT so VPN clients use VPS public IP; need this for evading geoblocking
  networking.nat = {
    enable = true;
    externalInterface = extIf;
    internalInterfaces = [ "wg0" ];
  };

  networking.firewall.trustedInterfaces = [ "wg0" ];
  networking.interfaces.wg0.ipv4.routes = [
    { address = "10.10.10.0"; prefixLength = 24; via = "10.10.11.201"; }
  ];

  networking.firewall.extraCommands = ''
    # Allow forwarding between WireGuard peers
    iptables -A FORWARD -i wg0 -o wg0 -j ACCEPT
    iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
  '';

  ################
  # wstunnel
  ################
  environment.systemPackages = with pkgs; [
    wstunnel
  ];

  sops.secrets."wstunnel/prefix" = { };

  systemd.services.wstunnel-wireguard = {
    description = "wstunnel for WireGuard over WebSocket";
    after = [ "network-online.target" "wg-quick-wg0.service" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = 2;
      DynamicUser = true;
      NoNewPrivileges = true;

      # Caddy terminates TLS. wstunnel stays local and plain HTTP/WebSocket.
      ExecStart = ''
        ${pkgs.wstunnel}/bin/wstunnel server \
          ws://127.0.0.1:${toString wsPort} \
          --restrict-http-upgrade-path-prefix 4mtGd8IBgogyJr54ihNaTDirU4SkTqjb7dvhnRy6dcnYSUsiMgoVCqQXaHuocYcv \
          --restrict-to 127.0.0.1:${toString wgPort}
      '';
    };
  };

  ################
  # caddy
  ################
  services.caddy = {
    enable = true;

    virtualHosts.${tunnelDomain}.extraConfig = ''
      @wst {
        path /4mtGd8IBgogyJr54ihNaTDirU4SkTqjb7dvhnRy6dcnYSUsiMgoVCqQXaHuocYcv/events
        header Upgrade websocket
        header Connection *upgrade*
        method GET
      }

      handle @wst {
        reverse_proxy 127.0.0.1:51821 { }
      }

      respond "not found" 404
    '';
  };
}
