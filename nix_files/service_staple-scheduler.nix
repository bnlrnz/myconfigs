{ config, pkgs, lib, ... }:

let
  appName = "staple-scheduler";
  appPort = "45555";
  domain = "stalldienst.b3lo.de";
  appPkg = pkgs.buildGoModule {
    pname = "staple-scheduler";
    version = "0.1.0";
    src = /home/ben/staple-scheduler;
    vendorHash = "sha256-q23ouUNW+bJP4Jab1ow6wDbzAOQHYjasiQId8pVkcFY=";
    doCheck = false;
    postInstall = ''
      mkdir -p $out/bin/templates
      cp -r ${/home/ben/staple-scheduler}/templates/* $out/bin/templates/
    '';
  };
in
  {
  users.users.${appName} = {
    isSystemUser = true;
    group = appName;
  };
  users.groups.${appName} = { };

  systemd.services.${appName} = {
    preStart = ''
      mkdir -p /var/lib/staple-scheduler/templates
      cp -r ${appPkg}/bin/templates/* /var/lib/staple-scheduler/templates/ || true
    '';
    description = "Gin web app";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      User = appName;
      Group = appName;
      ExecStart = "${appPkg}/bin/staple-scheduler";
      Restart = "always";
      Type = "simple";
      Environment = "STAPLE_SCHEDULER_PORT=${appPort}";
      StateDirectory = "/var/lib/${appName}";
      WorkingDirectory = "/var/lib/${appName}";
    };
  };
  systemd.tmpfiles.rules = [
    "d /var/lib/${appName} 0750 ${appName} ${appName} -"
  ];

  services.caddy.virtualHosts.${domain} = {
    extraConfig = ''
      reverse_proxy localhost:${builtins.toString appPort}
    '';
  };
}

