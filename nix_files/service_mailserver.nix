
{ config, lib, pkgs, ... }:
let
  snappymail_webroot = "/var/lib/snappymail";
in{
  imports = [
      (builtins.fetchTarball {
        # Pick a release version you are interested in and set its hash, e.g.
        url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/nixos-25.11/nixos-mailserver-nixos-25.11.tar.gz";
        # To get the sha256 of the nixos-mailserver tarball, we can use the nix-prefetch-url command:
        # release="nixos-24.11"; nix-prefetch-url "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/${release}/nixos-mailserver-${release}.tar.gz" --unpack
        sha256 = "16kanlk74xnj7xgmjsj7pahy31hlxqcbv76xnsg8qbh54b0hwxgq";
      })
  ];

  services.caddy.virtualHosts."mail.b3lo.de".extraConfig = ''
        root * ${pkgs.snappymail}
        php_fastcgi unix/${config.services.phpfpm.pools.snappymail.socket}
        file_server
        encode gzip

        @writable path_regexp writable ^/data/(.*)$
        handle @writable {
          root * ${snappymail_webroot}
          php_fastcgi unix/${config.services.phpfpm.pools.snappymail.socket}
        }
    '';

  ###############
  # Mailserver
  ###############
  mailserver = {
    stateVersion = 3;
    enable = true;
    fqdn = "mail.b3lo.de";
    domains = [ "b3lo.de" ];
    
    # A list of all login accounts. To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    loginAccounts = {
      "ben@b3lo.de" = {
        hashedPasswordFile = "/etc/ben_mailpw";
        aliases = [ "me@b3lo.de" "security@b3lo.de" ];
      };
    };

    certificateScheme = "manual";
    certificateFile = "/etc/ssl/private/mailserver/fullchain.pem";
    keyFile = "/etc/ssl/private/mailserver/privkey.pem";
  };
  users.groups.mail = { };  # Ensure group exists

  users.users.postfix.extraGroups = [ "mail" ];
  users.users.dovecot2.extraGroups = [ "mail" ];

  systemd.services.link-caddy-mailserver-certs = {
    wantedBy = [ "multi-user.target" ];
    before = [ "postfix.service" "dovecot2.service" ];
    script = ''
    CERT_SRC_DIR="/var/lib/caddy/.local/share/caddy/certificates/acme-v02.api.letsencrypt.org-directory/mail.b3lo.de"
    CERT_DST_DIR="/etc/ssl/private/mailserver"

    mkdir -p $CERT_DST_DIR

    ln -sf $CERT_SRC_DIR/mail.b3lo.de.crt $CERT_DST_DIR/fullchain.pem
    ln -sf $CERT_SRC_DIR/mail.b3lo.de.key $CERT_DST_DIR/privkey.pem

    chmod 640 $CERT_DST_DIR/*
    chown caddy:mail $CERT_DST_DIR/*
    '';
    serviceConfig = {
      Type = "oneshot";
    };
  };

  ###############
  # Snappymail
  ###############
  systemd.tmpfiles.rules = [
    "d ${snappymail_webroot} 0750 caddy caddy - -"
  ];

  # PHP-FPM running as caddy user
  services.phpfpm.pools.snappymail = {
    user = "caddy";
    group = "caddy";
    phpOptions = ''
      upload_max_filesize = 100M
      post_max_size = 50M
    '';
    settings = {
      "pm" = "dynamic";
      "pm.max_children" = "5";
      "pm.start_servers" = "2";
      "pm.min_spare_servers" = "1";
      "pm.max_spare_servers" = "3";
      "listen.owner" = "caddy";
      "listen.group" = "caddy";
      "listen.mode" = "0600";
    };
  };
}