
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
    # nextcloud-extras for caddy support
    "${fetchTarball {
        url = "https://github.com/onny/nixos-nextcloud-testumgebung/archive/fa6f062830b4bc3cedb9694c1dbf01d5fdf775ac.tar.gz";
        sha256 = "0gzd0276b8da3ykapgqks2zhsqdv4jjvbv97dsxg0hgrhb74z0fs";}}/nextcloud-extras.nix"
  ]

  ###############
  # Nextcloud
  ###############
  services.nextcloud = {
    enable = true;
    webserver = "caddy";
    package = pkgs.nextcloud32;
    config.adminpassFile = "/etc/nextcloud-admin-pass";
    config.dbtype = "sqlite";
    extraApps = {
      #inherit (config.services.nextcloud.package.packages.apps) onlyoffice;
    };
    extraAppsEnable = true;
    appstoreEnable = true;
    hostName = "cloud.b3lo.de";
    https = true;
    configureRedis = true;
    database.createLocally = true;
    maxUploadSize = "20G";
    settings.trusted_proxies = [ "127.0.0.1" ];
    settings.trusted_domains = [ "cloud.b3lo.de" "127.0.0.1" "149.102.140.151" "oo.b3lo.de" ];
    settings.default_phone_region = "DE";
    phpOptions = {
      "opcache.interned_strings_buffer" = "10";
    };
  };

  # this is now done by nextlcoud-extras.nix webserver = "caddy";
  # virtualHosts."cloud.b3lo.de".extraConfig = ''
  #   header / {
  #   	  Strict-Transport-Security "max-age=31536000;"
  #   	  X-XSS-Protection "1; mode=block"
  #   	  X-Content-Type-Options "nosniff"
  #   	  X-Frame-Options "DENY"
  #     }
  #     redir /.well-known/carddav /remote.php/dav/ 301
  #     redir /.well-known/caldav /remote.php/dav/ 301
  #     reverse_proxy http://localhost_nextcloud
  # '';
}