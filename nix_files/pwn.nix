{ pkgs, ... }: 
{
  environment.systemPackages = with pkgs; [
    binwalk
    burpsuite
    feroxbuster
    file
    gef
    ghidra-bin
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
}
