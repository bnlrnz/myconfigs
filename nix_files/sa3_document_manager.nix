{ config, pkgs, ... }:

let
  flaskAppDir = "/var/www/sa3_document_manager"; # Path to your Flask app
  pythonEnv = pkgs.python313.withPackages (ps: with ps; [ flask flask-cors gunicorn pandas openpyxl pathlib2 requests ]);
in
{
  # Define the service
  systemd.services.sa3_document_manager = {
    description = "Flask app deployed with gunicorn";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${pythonEnv}/bin/gunicorn --workers 3 --bind unix:/var/www/sa3_document_manager/sa3_document_manager.sock wsgi:app";
      WorkingDirectory = flaskAppDir;
      User = "caddy";  # Replace with the user that should run the service
      Group = "caddy"; # Replace with the group that should run the service
      Restart = "always";
    };
  };
}
