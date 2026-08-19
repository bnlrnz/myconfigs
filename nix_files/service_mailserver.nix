{ config, lib, pkgs, ... }:
let
  snappymail_webroot = "/var/lib/snappymail";

  snappymailDracula = pkgs.runCommand "snappymail-dracula" {} ''
    mkdir -p $out
    cp -r ${pkgs.snappymail}/* $out/

    mkdir -p $out/themes/Dracula

    cat > $out/themes/Dracula/styles.css <<'EOF'
:root {
	color-scheme: dark;

	/* MAIN */
	--main-color: #F8F8F2;              /* Foreground */
	--main-bg-color: #282A36;          /* Background */
	--main-bg-image: none;             /* url("images/background.png"); */
	--main-bg-size: auto;
	--main-bg-repeat: repeat;
	--main-font-size: 14px;
	--link-color: #bd93f9;             /* Cyan */
	--border-color: #44475A;           /* Selection / borders */
	--border-radius: 5px;
	--hr-color: #44475A;

	--panel-bg-clr: #21222C;           /* Background (dark) */

	--warning-clr: #FFB86C;            /* Orange */
	--warning-bg-clr: #2B2520;
	--warning-border-clr: #FFB86C;

	--error-clr: #FF5555;              /* Red */
	--error-bg-clr: #2A1E23;
	--error-border-clr: #FF5555;

	--info-clr: #0081D6;               /* Functional Cyan from spec */
	--info-bg-clr: #1D2530;
	--info-border-clr: #0081D6;

	/* LOADING */
	--loading-color: #F8F8F2;
	--loading-text-shadow: none;       /* 0px 1px 0px rgba(0, 0, 0, 0.5); */

	/* LOGIN */
	--login-color: #F8F8F2;
	--login-bg-color: #21222C;
	--login-box-shadow: 0px 2px 10px rgba(0,0,0,0.6);
	--login-border: 1px solid #44475A;
	--login-border-radius: 7px;

	--spinner-color: #50FA7B;          /* Green */

	/* MENU */
	--dropdown-menu-color: #F8F8F2;
	--dropdown-menu-bg-color: #282A36;
	--dropdown-menu-hover-bg-color: #44475A;
	--dropdown-menu-hover-color: #F8F8F2;
	--dropdown-menu-disabled-color: #6272A4;  /* Comment */
	--dropdown-menu-border-clr: rgba(0,0,0,.6);

	/* FOLDERS */
	--folders-color: #F8F8F2;
	--folders-disabled-color: #6272A4;
	--folders-selected-color: #F8F8F2;
	--folders-selected-bg-color: #44475A;
	--folders-focused-color: #F8F8F2;
	--folders-focused-bg-color: #44475A;
	--folders-hover-color: #F8F8F2;
	--folders-hover-bg-color: #343746;
	--folders-drop-color: #F8F8F2;
	--folders-drop-bg-color: #BD93F9;  /* Purple accent */
	--unread-count-color: #282A36;
	--unread-count-bg-color: #FF79C6;  /* Pink badge */

	/* SETTINGS */
	--settings-menu-color: #F8F8F2;
	--settings-menu-selected-color: #F8F8F2;
	--settings-menu-selected-bg-color: #44475A;
	--settings-menu-hover-color: #F8F8F2;
	--settings-menu-hover-bg-color: #343746;

	/* MESSAGES */
	--message-list-toolbar-bg-color: #21222C;
	--message-header-bg-clr: #343746;

	/* DIALOGS */
	--dialog-clr: #F8F8F2;
	--dialog-bg-clr: #282A36;
	--dialog-border-clr: rgba(0,0,0,.7);
	--dialog-border-radius: 6px;

	/* FORMS */
	--btn-clr: #F8F8F2;
	--btn-bg-clr: #44475A;
	--btn-border-clr: #44475A;
	--btn-border-radius: 3px;
	--btn-success-bg-clr: #FF79C6;    
	--btn-danger-bg-clr: #FF5555;      /* Red */

	--input-clr: #F8F8F2;
	--input-bg-clr: #282A36;
	--input-border-clr: #44475A;
	--input-border-radius: 3px;
	--input-focus-border-clr: #BD93F9; /* Purple highlight */

	/* TABLES */
	--tr-hover-bg-clr: #343746;
	--tr-odd-bg-clr: #21222C;          /* when striped */

	/* TABS */
	--tab-active-bg-clr: #282A36;
	--tab-hover-border-clr: #44475A;

	--smDialogShrink: 20px;
	--smMainShadow: 0 2px 8px rgba(0, 0, 0, 0.5);
}

/* Default background for HTML message body */
.mail-body {
  background-color: #ffffff;  /* default canvas */
  color: #000000;             /* readable plain text */
}

/* Toolbar + generic buttons */
.toolbar {
  background-color: var(--panel-bg-clr);
  border-bottom: 1px solid var(--border-color);
}

/* Base Dracula button look */
.toolbar .button,
.toolbar .btn,
.button,
.btn {
  background-color: var(--btn-bg-clr);
  color: var(--btn-clr);
  border: 1px solid var(--btn-border-clr);
  border-radius: var(--btn-border-radius);
}

/* Hover state */
.toolbar .button:hover,
.toolbar .btn:hover,
.button:hover,
.btn:hover {
  background-color: var(--btn-success-bg-clr); /* subtle accent */
  color: #282A36; /* dark text on accent */
}

/* New message should NOT be hardcoded neon green */
.toolbar .button.compose,
.toolbar .button.new-message {
  background-color: var(--btn-bg-clr);
  color: var(--btn-clr);
  border-color: var(--btn-border-clr);
}

/* Optional: slightly stronger hover just for New message */
.toolbar .button.compose:hover,
.toolbar .button.new-message:hover {
  background-color: var(--btn-success-bg-clr);
  color: #282A36;
}

/* message list selected */
.messageListItem.selected,
.messageListItem.selected:hover {
  background-color: #CCABFA6B;
  border-left-color: #BD93F9;
}

/* message list unread/unseen */
.messageListItem.unseen,
.messageListItem.unseen.focused,
.messageListItem.unseen:hover {
  background-color: #FF79C62B;
  border-left-color: #FF79C6;
}

/* message list hover */
.messageListItem:hover {
  background-color: #282A36DE;
}

EOF
  '';
in{
  imports = [
    (builtins.fetchTarball {
      # Pick a release version you are interested in and set its hash, e.g.
      url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/nixos-26.05/nixos-mailserver-nixos-26.05.tar.gz";
      # To get the sha256 of the nixos-mailserver tarball, we can use the nix-prefetch-url command:
      # release="nixos-24.11"; nix-prefetch-url "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/${release}/nixos-mailserver-${release}.tar.gz" --unpack
      sha256 = "0jicsxjg2c3vami08csrfccw6273yv12627ws8qx69lg5wz43abx";
    })
  ];

  services.caddy.virtualHosts."mail.b3lo.de".extraConfig = ''
        root * ${snappymailDracula}
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

    fullTextSearch = {
      enable = true;
      # index new email as they arrive
      autoIndex = true;
      # only query index
      fallback = false;
    };

    # A list of all login accounts. To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    accounts = {
      "ben@b3lo.de" = {
        hashedPasswordFile = "/etc/ben_mailpw";
        aliases = [ "me@b3lo.de" "security@b3lo.de" "ben-bsi@b3lo.de" ];
        sieveScript = ''
          require ["fileinto", "mailbox"];

          if allof(address :is "to" "3GPP_TSG_SA_WG3@list.etsi.org", header :contains "subject" "5.1.4") {
            fileinto :create "INBOX.3GPP SA3.SCAS_Container";
            stop;
          }

          if allof(address :is "to" "3GPP_TSG_SA_WG3@list.etsi.org", header :contains "subject" "5.2.2") {
            fileinto :create "INBOX.3GPP SA3.SCAS_Container";
            stop;
          }
          
          if allof(address :is "to" "3GPP_TSG_SA_WG3@list.etsi.org", header :contains "subject" "5.1.3") {
            fileinto :create "INBOX.3GPP SA3.SCAS_CCF";
            stop;
          }

          if allof(address :is "to" "3GPP_TSG_SA_WG3@list.etsi.org", header :contains "subject" "5.1.2") {
            fileinto :create "INBOX.3GPP SA3.SCAS";
            stop;
          }

          if address :is "to" "3GPP_TSG_SA_WG3@list.etsi.org" {
            fileinto :create "INBOX.3GPP SA3";
            stop;
          }
        '';
      };
      "lisanne-bsi@b3lo.de" = {
        hashedPasswordFile = "/etc/lisanne_mailpw";
        aliases = [ "lisanne@b3lo.de" ];
        sieveScript = ''
          require ["fileinto", "mailbox"];

          if allof(address :is "to" "3GPP_TSG_SA_WG3@list.etsi.org", address :contains "reply-to" "daniel.cho@ERICSSON.COM") {
            fileinto :create "INBOX.3GPP SA3.<3";
            stop;
          }

          if allof(address :is "to" "3GPP_TSG_SA_WG3@list.etsi.org", address :contains "reply-to" "jeffrey.cichonski@nist.gov") {
            fileinto :create "INBOX.3GPP SA3.<3";
            stop;
          }

          if allof(address :is "to" "3GPP_TSG_SA_WG3@list.etsi.org", header :contains "subject" "5.1.2") {
            fileinto :create "INBOX.3GPP SA3.SCAS_Container";
            stop;
          }
          
          if allof(address :is "to" "3GPP_TSG_SA_WG3@list.etsi.org", header :contains "subject" "5.1.3") {
            fileinto :create "INBOX.3GPP SA3.SCAS_CCF";
            stop;
          }

          if allof(address :is "to" "3GPP_TSG_SA_WG3@list.etsi.org", header :contains "subject" "5.1.2") {
            fileinto :create "INBOX.3GPP SA3.SCAS";
            stop;
          }

          if address :is "to" "3GPP_TSG_SA_WG3@list.etsi.org" {
            fileinto :create "INBOX.3GPP SA3";
            stop;
          }
        '';
      };
    };

    #certificateScheme = "manual";
    x509.certificateFile = "/etc/ssl/private/mailserver/fullchain.pem";
    x509.privateKeyFile = "/etc/ssl/private/mailserver/privkey.pem";
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

  ###############
  # Mail Backup
  ###############

  systemd = {
    services.mail-to-opencloud-backup = {
      description = "Backup mailserver to Opencloud user folder";

      # Required packages for the backup script
      path = with pkgs; [ rsync ];

      unitConfig = {
        OnSuccess = "opencloud.service";
      };

      serviceConfig = {
        Type = "oneshot";
        # Run as root to access both mail and nextcloud directories
        User = "root";

        # Security hardening (optional but recommended)
        ProtectSystem = "strict";
        ReadWritePaths = [
          "/var/vmail"
          "/var/lib/opencloud/storage/users/users/aeb91904-01ed-4b87-84e9-8a88a161fee5/Sonstiges"
        ];
        ProtectHome = true;
        NoNewPrivileges = true;

        # Logging
        StandardOutput = "journal";
        StandardError = "journal";

        ExecStopPost = "/run/current-system/sw/bin/systemctl restart opencloud.service";
      };

      script = ''
      set -eu

      # Source mail directory (adjust to your mailDirectory setting)
      MAIL_SOURCE="/var/vmail"

      # Opencloud destination (adjust username as needed)
      NC_DEST="/var/lib/opencloud/storage/users/users/aeb91904-01ed-4b87-84e9-8a88a161fee5/Sonstiges/Backup_Mails"

      # Create destination if it doesn't exist
      mkdir -p "$NC_DEST"

      # Backup with rsync
      # -a: archive mode (preserves permissions, ownership, timestamps)
      # -v: verbose
      # --delete: remove files in destination that don't exist in source
      # --stats: show transfer statistics
      ${pkgs.rsync}/bin/rsync \
      -av \
      --delete \
      --stats \
      --exclude=".Trash" \
      "$MAIL_SOURCE/" "$NC_DEST/"

      # Fix ownership for Opencloud (adjust user based on your install)
      chown -R opencloud:opencloud "$NC_DEST"

      echo "Mail backup completed successfully"
      '';
    };

    timers.mail-to-opencloud-backup = {
      description = "Daily mail to Opencloud backup";
      wantedBy = [ "timers.target" ];

      # Run daily at 2 AM
      timerConfig = {
        OnCalendar = "*-*-* 02:34:13 Europe/Berlin";
        Persistent = true;  # catch up if system was down
      };

      # Associate with service
      partOf = [ "mail-to-opencloud-backup.service" ];
    };
  };

}
