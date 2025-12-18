{ config, pkgs, ... }:

let
  domain = "cloud.b3lo.de";
  collaboraDomain = "oo.b3lo.de";
in
  {
  # 1. OpenCloud Service
  services.opencloud = {
    enable = true;
    url = "https://${domain}";

    # Configure OpenCloud to use Collabora
    settings = {
      # These settings depend on the specific OpenCloud version structure
      # but generally follow the OCIS/Go-backend pattern:
      wopi = {
        wopi_server_url = "https://${collaboraDomain}";
        insecure = false; 
      };
    };

    # Environment variables for sensitive or specific runtime config
    environment = {
      IDM_ADMIN_PASSWORD = "superseca9f82czjn05za803k,ysxrjglvkym3.<F8>58c92tuazm9pxz";
      OC_LOG_LEVEL = "info";
      OC_INSECURE = "true";
      # Optional: You might also need these if they aren't auto-detected
      PROXY_TLS = "false"; 
      OCIS_URL = "https://cloud.b3lo.de";
    };
  };

  # 2. Collabora Online (CODE) Service
  services.collabora-online = {
    enable = true;
    port = 9980;

    settings = {
      # SSL is handled by Caddy, so we terminate it there
      ssl = {
        enable = false;
        termination = true;
      };

      # Network settings: Listen only on localhost
      net = {
        proto = "IPv4";
        listen = "loopback";
      };

      # WOPI Host: IMPORTANT
      # You must tell Collabora to trust your OpenCloud domain.
      # The dot needs to be escaped for the regex, or just use the domain.
      storage = {
        wopi = {
          host = [ "${domain}" ];
        };
      };
    };
  };

  # 3. Caddy Reverse Proxy
  services.caddy = {
    virtualHosts = {
      # Proxy for OpenCloud
      "${domain}" = {
        extraConfig = ''
          reverse_proxy http://127.0.0.1:9200 {
            # Pass correct headers so OpenCloud knows the real client IP
            header_up X-Real-IP {remote}
            header_up X-Forwarded-For {remote}
            header_up X-Forwarded-Proto https 
            header_up X-Forwarded-Port 443
            header_up Upgrade {>Upgrade}
            header_up Connection {>Connection}
          }
        '';
      };

      # Proxy for Collabora Online
      "${collaboraDomain}" = {
        extraConfig = ''
          reverse_proxy http://127.0.0.1:9980 {
            # Collabora uses WebSockets, Caddy handles this automatically
            header_up Host {host}
            header_up X-Real-IP {remote}
            header_up X-Forwarded-For {remote}
            header_up X-Forwarded-Proto https
            header_up X-Forwarded-Port 443
            header_up Upgrade {>Upgrade}
            header_up Connection {>Connection}
          }
        '';
      };
    };
  };

  # Firewall: Open ports 80 and 443 for Caddy
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}

