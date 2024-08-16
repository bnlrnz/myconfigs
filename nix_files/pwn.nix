{ pkgs, ... }: 
{
  environment.systemPackages = with pkgs; [
    burpsuite
    feroxbuster
    gef
    ghidra-bin
    gobuster
    hashcat
    padbuster
    pwndbg
    pwninit
    pwntools
  ];
}
