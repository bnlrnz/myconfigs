{ pkgs, ... }:

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
  ];

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
