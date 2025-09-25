{ pkgs, config, lib, ... }: 
{

  networking.nameservers = [ "10.50.1.1" ];
  networking.firewall.allowedTCPPorts = [
    2049 # NFSv4
  ];
  networking.firewall.allowedUDPPorts = [
    4431 # Fortinet VPN
  ];

  # nfs mounts
  services.rpcbind.enable = true;

  users.groups.fuse = { };

  networking.networkmanager.ensureProfiles.profiles = {
    "TEMIS VPN" = {
      connection = {
        autoconnect = "false";
        id = "TEMIS VPN";
        permissions = "user:belo:;";
        type = "vpn";
        uuid = "060dd53b-2787-4487-81d3-d2d2f119cef2";
      };
      ipv4 = {
        method = "auto";
        never-default = "true";
      };
      ipv6 = {
        addr-gen-mode = "stable-privacy";
        method = "auto";
      };
      proxy = { };
      vpn = {
        authtype = "password";
        autoconnect-flags = "0";
        certsigs-flags = "0";
        cookie-flags = "2";
        disable_udp = "no";
        enable_csd_trojan = "no";
        gateway = "vpn.temislab.de:4431";
        gateway-flags = "2";
        gwcert-flags = "2";
        lasthost-flags = "0";
        pem_passphrase_fsid = "no";
        prevent_invalid_cert = "no";
        protocol = "fortinet";
        resolve-flags = "2";
        service-type = "org.freedesktop.NetworkManager.openconnect";
        stoken_source = "disabled";
        useragent = "belo";
        xmlconfig-flags = "0";
      };
      vpn-secrets = {
        "certificate:\\5b64:ff9b::cf59:6b02\\5d:4431" =
          "pin-sha256:uqrIE1lFD0L4iSDjvTlcnPzZ0VJzrZ2jeffMbi4a5UQ=";
        "form:_login:username" = "belo";
        lasthost = "vpn.temislab.de:4431";
        save_passwords = "yes";
      };
    };
  };
  fileSystems."/mnt/org-sz31" = {
    device = "fs1.temislab.de:/vsanfs/org-sz31";
    fsType = "nfs";
    options = ["x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" "hard" "nfsvers=4.1" "sec=sys" "rw" "intr" "noexec" "nosuid" "timeo=20"];
  };

  fileSystems."/mnt/user-belo" = {
    device = "fs1.temislab.de:/vsanfs/user-belo";
    fsType = "nfs";
    options = ["x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" "nfsvers=4.1" ];
  };

  fileSystems."/mnt/svc-specbutler" = {
    device = "fs1.temislab.de:/vsanfs/svc-specbutler";
    fsType = "nfs";
    options = ["x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" "nfsvers=4.1" ];
  };

  fileSystems."/mnt/svc-scasbrowser" = {
    device = "fs1.temislab.de:/vsanfs/svc-scasbrowser";
    fsType = "nfs";
    options = ["x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" "nfsvers=4.1" ];
  };

  # PKI / self signed certificates
  security.pki.certificates = [
    # temislab.de root
    ''
-----BEGIN CERTIFICATE-----
MIIGeTCCBGGgAwIBAgIUYuEx9gFCVQK33pFh0nAoQLfXo7wwDQYJKoZIhvcNAQEL
BQAwgcsxCzAJBgNVBAYTAkRFMRYwFAYDVQQIDA1OaWVkZXJzYWNoc2VuMRAwDgYD
VQQHDAdGcmVpdGFsMT8wPQYDVQQKDDZCdW5kZXNhbXQgZsODwrxyIFNpY2hlcmhl
aXQgaW4gZGVyIEluZm9ybWF0aW9uc3RlY2huaWsxFjAUBgNVBAsMDVRlbWlzIFJv
b3QgQ0ExFjAUBgNVBAMMDVRlbWlzIFJvb3QgQ0ExITAfBgkqhkiG9w0BCQEWEnJv
b3RjYUBic2kuYnVuZC5kZTAeFw0yNTA3MjgxNTU5MzVaFw0zNTA3MjYxNTU5MzVa
MIHLMQswCQYDVQQGEwJERTEWMBQGA1UECAwNTmllZGVyc2FjaHNlbjEQMA4GA1UE
BwwHRnJlaXRhbDE/MD0GA1UECgw2QnVuZGVzYW10IGbDg8K8ciBTaWNoZXJoZWl0
IGluIGRlciBJbmZvcm1hdGlvbnN0ZWNobmlrMRYwFAYDVQQLDA1UZW1pcyBSb290
IENBMRYwFAYDVQQDDA1UZW1pcyBSb290IENBMSEwHwYJKoZIhvcNAQkBFhJyb290
Y2FAYnNpLmJ1bmQuZGUwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCj
8scQxPtg6AcAVYoLEFAC69Acv0lx16YhOmHJXultzZ10fk3CLXGUlbdR2qOgCT8B
YdRvbtm6XS9yeqz6DMreiFyaPEcMcNdVUsUI3OxwZVU2E7eTMwZZuxDgGgf/ohc6
1M8AJI29M1vLieUpEoiko1LUx7qpNGioLBVkSIjDLKDMT3jzkpmdnZqWy4yVe9cN
HBSUK8nbDOoeeKCWDUF7TqtM4kwZYKbpLebJ4qD+4vi3UI9ISUkw3xTCLapfycyi
t+b9NnihtJeychNjyrEeFJG8qax6nRJz3jUISEpr4NS1KleXt4LRlohT0VzuKhqo
ONiMFb4t0DVLGeobWMI1/WoBNgSukyqEc3wiZPHYGYNT3EVJiGlRp3aTA2MiQ7lp
JA2b1T4brMsW/2nX1GriARVX/S+lW12CaLI+hkI3mbC5Xpl2V4RriCmEQNbhd6dy
BycZ6XJu6Y9G6NhsHUuszsfB53eZVNg6TW/rJRuAl0o53N3B/Nh4nx+BFeOQwpSA
mrFtpNd1Z0VW1mefwqYRQUtcMnf3y9VdYh5bhRUjYk2jR25YY5d+05tJqDemlTKI
8fvDHdaz7p5+m4dOyQklF+rCHpNXdCXG93rUSzlmmmqKC8meiUntPcrA+eSOvePj
ygEaAAtswmkrGQ/Fbw+HvsWRZiYuk2tyBVXvvsk4KQIDAQABo1MwUTAdBgNVHQ4E
FgQUmkJMMQa7AsHw1jREwDkcfWY8UcYwHwYDVR0jBBgwFoAUmkJMMQa7AsHw1jRE
wDkcfWY8UcYwDwYDVR0TAQH/BAUwAwEB/zANBgkqhkiG9w0BAQsFAAOCAgEAMfL/
t8ZcHoZ1JWNB2dzQ+y0J5Jd4OJUzWeufoCGSQwFA5K+G2f86tzBHOv5XLDTxk0WJ
D5jET7wIb9myCPH7xmJTF4xJ+d+NY+imbrSMdq33qRnedARZ9BLrxDSvi9D7BmF8
iH9RFOmO0AZAetI7CplPoEPA6kc695EyxZykfnY13k3E4Co6SV5532lgYId2rtsU
tIjNiO4cJh2kik8ZxqYrmbodOZG0gCF37Z+X19ElKqHzBx0+EGFW5hDkU+OgyIWU
AuRYXu5WXfEfDaVTzemQtRlOKFs7jcqRWQQJD3HOenIS0VdNb+G9MbD3t04fmc3T
hfVvkkYelt72KYrDABIhcVFuc0+CcV7hmv2wdf7QYTcwxY0+IFrc3V8EoHqz99zx
xQtINvezjBbdcjKyzcLeIgO0sjEYeoiyuNsMK8fsnf01MYRoJT9aQcNp/vfA9j5j
PyNe/DnvswQhvAMjW3Y7EBDzabKhyClaBdi7YmvDm56S0l0+QtHVoE7rJef5uDTZ
3HoDiJdrhBNKs8B96ZmeEPrRsKSTioTvraOeVD7VYq+DJEvWgFHsnmDxyCf3geOQ
sho2dPCeltH3IEou1bned89Ho1+81vm6OaPSMOAnkdqhjX2cVIXEuVNk+GZ+p7Dt
C3b5szYmXwmI1g/vA4yLAulQ2KxGoaM/u6bEDYw=
-----END CERTIFICATE-----
    ''
  ];
}
