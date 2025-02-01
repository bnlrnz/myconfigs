{ pkgs, lib, ... }:

let
  ctf_ip = "10.13.37.10";
in
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

  security.sudo = {
    enable = true;
    extraRules = [{
      commands = [
        { command = "${pkgs.systemd}/bin/systemctl start wg-quick-bsictfwireguard.service"; options = [ "NOPASSWD" ]; }
        { command = "${pkgs.systemd}/bin/systemctl stop wg-quick-bsictfwireguard.service"; options = [ "NOPASSWD" ]; }
      ];
      groups = [ "wireguard" ];
    }];
  };

  # wireguard vpn
  networking.wg-quick.interfaces.bsictfwireguard = {
    autostart = false;

    address = [ "10.133.70.5/23" ];
    dns = [ "10.13.37.1, ctf.cert-bund.de" ];
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

  # ctf hosts
  networking.extraHosts =
    ''
      #${ctf_ip} vault.starfleet
      #${ctf_ip} medical.starfleet
      #${ctf_ip} crusher.starfleet
      #${ctf_ip} reynholm.industries
      #${ctf_ip} bornholm.reynholm.industries
      #${ctf_ip} recruiting.reynholm.industries
      #${ctf_ip} ldap.reynholm.industries
      #${ctf_ip} cdn.reynholm.industries
      #${ctf_ip} ns1.reynholm.industries
      #${ctf_ip} weird.reynholm.industries
      #${ctf_ip} usersearch.reynholm.industries
      #${ctf_ip} recruiter2.reynholm.industries
      ${ctf_ip} b2mynht0cjrunxa0cjnuy3l9.ctf.cert-bund.de
      ${ctf_ip} picshare
      #${ctf_ip} lana.ctf.cert-bund.de
      #${ctf_ip} cheryl.ctf.cert-bund.de
      #${ctf_ip} malory.ctf.cert-bund.de
    '';
}
