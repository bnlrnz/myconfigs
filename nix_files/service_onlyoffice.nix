
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

  import = [
  ]

  services.caddy.virtualHosts."oo.b3lo.de".extraConfig = ''
    header / {
        Strict-Transport-Security "max-age=31536000;"
        X-XSS-Protection "1; mode=block"
        X-Content-Type-Options "nosniff"
        X-Frame-Options "DENY"
    }

    @onlyoffice_versioned_path {
      path_regexp versioned ^/[^/]+/web-apps/(.*)$
    }
    rewrite @onlyoffice_versioned_path /web-apps/{re.versioned.1}

    @allfonts path_regexp allfonts ^/[^/]+/(sdkjs/common/AllFonts.js)$
    rewrite @allfonts /{re.allfonts.1}

    @fonts path_regexp fonts ^/[^/]+/(fonts/.*)$
    rewrite @fonts /{re.fonts.1}

    @api_js path_regexp api_js ^/[^/]+/(web-apps/apps/api/documents/api\.js)$
    rewrite @api_js /{re.api_js.1}

    @serviceworker path_regexp serviceworker ^/[^/]+/(document_editor_service_worker\.js)$
    rewrite @serviceworker /sdkjs/common/serviceworker/{re.serviceworker.1}

    @webapps_json path_regexp webapps_json ^/[^/]+/(web-apps)(/.*\.json)$
    rewrite @webapps_json /{re.webapps_json.1}{re.webapps_json.2}

    @sdkjs_plugins_json path_regexp sdkjs_plugins_json ^/[^/]+/(sdkjs-plugins)(/.*\.json)$
    rewrite @sdkjs_plugins_json /{re.sdkjs_plugins_json.1}{re.sdkjs_plugins_json.2}

    # Strip version/hash from /doc and /downloadas
    @doc path_regexp doc ^/[^/]+/(doc/.*)$
    rewrite @doc /{re.doc.1}

    @downloadas path_regexp downloadas ^/[^/]+/(downloadas/.*)$
    rewrite @downloadas /{re.downloadas.1}

    # (Add similar rules for /coauthoring if needed)

    @static_assets path_regexp static_assets ^/[^/]+/(web-apps|sdkjs|sdkjs-plugins|fonts|dictionaries|plugins\.json|themes\.json)(/.*)?$
    rewrite @static_assets /{re.static_assets.1}{re.static_assets.2}

    @internal path_regexp internal ^/[^/]+/internal(/.*)?$
    @info path_regexp info ^/[^/]+/info(/.*)?$

    reverse_proxy http://127.0.0.1:8888 {
        # Required to circumvent bug of Onlyoffice loading mixed non-https content
        header_up X-Forwarded-Proto https
        header_up X-Forwarded-Host oo.b3lo.de
        header_up X-Forwarded-Port 443
        header_up Upgrade {>Upgrade}
        header_up Connection {>Connection}
      }
  '';

  ###############
  # Onlyoffice
  ###############
  services.onlyoffice = {
    enable = true;
    #package = customOO;
    package = pkgs.unstable.onlyoffice-documentserver;
    hostname = "localhost_onlyoffice";
    jwtSecretFile = "/etc/nextcloud-admin-pass";
    securityNonceFile = "/etc/onlyoffice/onlyoffice-nonce";
    port = 8888; # port 8000 is the default port
  };

  # this is kinda hacky but the onlyffice module runs a nginx server at port 80 by default
  services.nginx.enable = lib.mkForce false;
  users.users.nginx = {
    group = "nginx";
    isSystemUser = true;
  };
  users.groups.nginx = {};

  services.nginx.virtualHosts."localhost_onlyoffice" = {
    listen = [ { addr = "127.0.0.1"; port = 8081; } ];
  };
}