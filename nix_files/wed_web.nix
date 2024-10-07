{ config, pkgs, ... }:

let
  flaskAppDir = "/var/www/wed_web"; # Path to your Flask app
  pythonEnv = pkgs.python312.withPackages (ps: with ps; [ flask gunicorn ]);
in
{
  # Define the service
  systemd.services.wed_web = {
    description = "Flask app deployed with gunicorn";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${pythonEnv}/bin/gunicorn --workers 3 --bind unix:/var/www/wed_web/wed_web.sock wsgi:app";
      WorkingDirectory = flaskAppDir;
      User = "caddy";  # Replace with the user that should run the service
      Group = "caddy"; # Replace with the group that should run the service
      Restart = "always";
    };
  };
}
