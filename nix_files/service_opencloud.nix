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

      collaboration = {
        enable = true;
      };
    };

    # Environment variables for sensitive or specific runtime config
    environment = {
      OC_LOG_LEVEL = "debug";

      # ========== TLS & Proxy ==========
      OC_INSECURE = "true";
      PROXY_TLS = "false";

      # ========== URL Configuration ==========
      OCIS_URL = "https://${domain}";
      OCIS_DOMAIN = "${domain}";

      # ========== CSP Configuration ==========
      PROXY_CSP_CONFIG_FILE_LOCATION = "/etc/opencloud/csp.yaml";

      # ========== Enable Services ==========
      OC_ADD_RUN_SERVICES = "collaboration,wopi";

      # ========== Collaboration Service ==========
      COLLABORATION_APP_NAME = "CollaboraOnline";
      COLLABORATION_APP_PRODUCT = "Collabora";
      COLLABORATION_APP_ADDR = "https://${collaboraDomain}";
      COLLABORATION_APP_INSECURE = "false";
      COLLABORATION_WOPI_SRC = "https://${domain}";
      COLLABORATION_HTTP_ADDR = "127.0.0.1:9300";
      COLLABORATION_GRPC_ADDR = "127.0.0.1:9301";

      # ========== Collaboration Store Configuration ==========
      COLLABORATION_STORE = "nats-js-kv";
      COLLABORATION_STORE_NODES = "127.0.0.1:9233";
      COLLABORATION_STORE_DATABASE = "collaboration";
      COLLABORATION_STORE_TTL = "30m";

      # ========== Proof Keys Configuration ==========
      COLLABORATION_APP_PROOF_DISABLE = "true";
    };
  };

  environment.etc."opencloud/csp.yaml".text = ''
    directives:
      child-src:
        - "'self'"
      connect-src:
        - "'self'"
        - "blob:"
        - "https://raw.githubusercontent.com/opencloud-eu/awesome-apps/"
        - "https://update.opencloud.eu/"
      default-src:
        - "'none'"
      font-src:
        - "'self'"
      frame-ancestors:
        - "'self'"
      frame-src:
        - "'self'"
        - "blob:"
        - "https://embed.diagrams.net/"
        - "https://${collaboraDomain}/"
        - "https://docs.opencloud.eu"
      img-src:
        - "'self'"
        - "data:"
        - "blob:"
        - "https://raw.githubusercontent.com/opencloud-eu/awesome-apps/"
        - "https://tile.openstreetmap.org/"
        - "https://${collaboraDomain}/"
      manifest-src:
        - "'self'"
      media-src:
        - "'self'"
      object-src:
        - "'self'"
        - "blob:"
      script-src:
        - "'self'"
        - "'unsafe-inline'"
      style-src:
        - "'self'"
        - "'unsafe-inline'"
  '';

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
        post_allow = ["::1"];
      };

      admin_console.enable = "false";
      admin_console.username = "admin";
      admin_console.password = "";

      # WOPI Host: IMPORTANT
      # You must tell Collabora to trust your OpenCloud domain.
      # The dot needs to be escaped for the regex, or just use the domain.
      storage = {
        wopi = {
          "@allow" = true;
          host = [ "${domain}" "127.0.0.1:9300" ];
        };
      };

      server_name = "${collaboraDomain}";
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
          }
        '';
      };
    };
  };

  # Firewall: Open ports 80 and 443 for Caddy
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}

