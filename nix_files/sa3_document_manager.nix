{ config, pkgs, ... }:
let
  unstable = import (fetchTarball "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz") { config = config.nixpkgs.config; };

  pythonEnv = unstable.python313.withPackages (ps: with ps; [
    flask
    flask-cors
    gunicorn
    pandas
    markdown
    openpyxl
    pathlib2
    requests
    tkinter
    fastmcp
  ]);

in
{
  systemd.services.sa3_document_manager = {
    description = "Flask app deployed with gunicorn";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${pythonEnv}/bin/gunicorn --workers 3 --bind unix:/var/www/sa3_document_manager/sa3_document_manager.sock wsgi:app";
      WorkingDirectory = "/var/www/sa3_document_manager";
      User = "caddy";  # Replace with the user that should run the service
      Group = "caddy"; # Replace with the group that should run the service
      Restart = "always";
    };
  };

  systemd.services.scas_browser = {
    description = "Flask app deployed with gunicorn";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${pythonEnv}/bin/gunicorn --workers 3 --bind unix:/var/www/scas_browser/scas_browser.sock wsgi:app";
      WorkingDirectory = "/var/www/scas_browser";
      User = "caddy";  # Replace with the user that should run the service
      Group = "caddy"; # Replace with the group that should run the service
      Restart = "always";
    };
  };


  systemd.services.sa3_mcp = {
    description = "SA3 MCP Server (SSE Transport)";
    after = [ "network.target" "sa3_document_manager.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${pythonEnv}/bin/python /var/www/sa3_document_manager/sa3_document_manager_mcp_server.py";
      WorkingDirectory = "/var/www/sa3_document_manager";
      User = "caddy";
      Group = "caddy";
      Restart = "always";
    
      Environment = "API_BASE_URL=http://sa3.b3lo.de";
    
      # Security hardening
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      ReadWritePaths = "/var/www/sa3_document_manager";
  };
};
}
