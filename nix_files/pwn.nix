{ pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    binwalk
    burpsuite
    feroxbuster
    file
    gef
    unstable.ghidra-bin
    gobuster
    hashcat
    lldb
    lldb.lib
    ltrace
    padbuster
    pwndbg
    pwninit
    pwntools
    sqlmap
    steghide
    strace
    wireguard-tools
  ];

  # introducing a wireguard group
  users.groups.wireguard = {};

  security.sudo = {
    enable = true;
    extraRules = [{
      commands = [
        { command = "/run/current-system/sw/bin/systemctl start wg-quick-bsictfwireguard.service"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/systemctl stop wg-quick-bsictfwireguard.service"; options = [ "NOPASSWD" ]; }
      ];
      groups = [ "wireguard" ];
    }];
  };

  # wireguard vpn
  networking.wg-quick.interfaces.bsictfwireguard = {
    autostart = false;

    address = [ "10.133.70.5/23" ];
    dns = [ "10.133.7.150, ctf.cert-bund.de" ];
    privateKeyFile = "/root/bsictfwireguard_private_key";
    mtu = 1400;

    peers = [
      {
        publicKey = "hz07Q5QYYPGwoLFr7TDK0wGVqjMBwbEaXy9yf0qDSjA=";
        presharedKeyFile = "/root/bsictfwireguard_preshared_key";
        allowedIPs = [ "10.13.37.0/24" "10.133.7.0/24" ];
        endpoint = "vpn.ctf.cert-bund.de:1337";
        persistentKeepalive = 25;
      }
    ];
  };

  # for wireguard VPN
  networking.firewall.checkReversePath = false;
}
