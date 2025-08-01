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
    # cloud.temislab.de
    ''
      -----BEGIN CERTIFICATE-----
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
-----END CERTIFICATE-----
    ''
    # gitlab.temislab.de
    ''
      -----BEGIN CERTIFICATE-----
MIID5zCCAs+gAwIBAgIUf3Pp/S9KvLBSkhJmPozFKvJyFT8wDQYJKoZIhvcNAQEL
BQAwgY0xCzAJBgNVBAYTAkRFMQ8wDQYDVQQIDAZTYXhvbnkxEDAOBgNVBAcMB0Zy
ZWl0YWwxDDAKBgNVBAoMA0JTSTEOMAwGA1UECwwFVEVNSVMxGzAZBgNVBAMMEmdp
dGxhYi50ZW1pc2xhYi5kZTEgMB4GCSqGSIb3DQEJARYRdGVtaXNAYnNpLmJ1bmQu
ZGUwHhcNMjMwODAzMDkxODIzWhcNMjUwNzIzMDkxODIzWjBrMQswCQYDVQQGEwJE
RTEPMA0GA1UECAwGU2F4b255MRAwDgYDVQQHDAdGcmVpdGFsMQwwCgYDVQQKDANC
U0kxDjAMBgNVBAsMBVRFTUlTMRswGQYDVQQDDBJnaXRsYWIudGVtaXNsYWIuZGUw
ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCyEzPVyYskSpSbE/4hccor
gJy7WIFupwwhfL9uWnNZDyUgqsTnSryb35uGGngyCeWcz3obkVSNCQEOovmywZkV
ffhu4BuY4r+lbE3uHr/sOJpDWqDAv7Zy+AkO4PoaqgrCErtdIhumInoZZ5saV534
pKGDYu9OZdRm1xLoZSuAZizXHE1Ans/wdXKzULxK85pb0ArLq/vzNlZkuOqatLgj
IvkVwpuJ3531cVer+aII5+jJlUVlC2hKVfeDj0jCb7Wkwl1sp9uM7UBHw/b/bdij
suL1ZkAiDvGw74bBEBYGoatez7SNAxyB6GOShhGiXIGAd7C+RXe8+t5fVYdzWjOP
AgMBAAGjYDBeMB8GA1UdIwQYMBaAFCpMAyq4pPx16ICpKUE9OyVpVt7zMAkGA1Ud
EwQCMAAwCwYDVR0PBAQDAgTwMCMGA1UdEQQcMBqCEmdpdGxhYi50ZW1pc2xhYi5k
ZYcECjMBZTANBgkqhkiG9w0BAQsFAAOCAQEAf3cWB0O/MGhZXqIUm1Jqd95YIaSO
L7fIuhuyTZ8GXWhd0Vk71BEBuUrsULj0/ArcD3RVThzAoGJPXN1BV3fYVNoDjYf6
Rr0okllsrVAkO1aX3gSlT/wmxobYtWbCUGRK25QEuM+FBpmeW7nsRgAychGkuCZo
ioeKnmyvz76vEhQ9ApdjrudVsVj3FLC6B/pZB1xCvrmbLXRnrmsk8l8BDgR0PN5e
OS82wdIR1ige0OeY8QHALirL2OQ4uIyzvOllKKmk+d/5ivKubRARqdo6ET68m0ds
2x2nAS09ztbrffIWQUulfpN8NDf46bDSAzeFww5oczYTBAGg2dOlNTatmA==
-----END CERTIFICATE-----
    ''
    # ldap.temislab.de
    ''
-----BEGIN CERTIFICATE-----
MIIF8DCCA9igAwIBAgIUK1UoYBlCLF7URkR7tSne+9MfcYEwDQYJKoZIhvcNAQEL
BQAwejELMAkGA1UEBhMCREUxEDAOBgNVBAcMB0ZyZWl0YWwxDDAKBgNVBAoMA0JT
STEOMAwGA1UECwwFVEVNSVMxGTAXBgNVBAMMEGxkYXAudGVtaXNsYWIuZGUxIDAe
BgkqhkiG9w0BCQEWEXRlbWlzQGJzaS5idW5kLmRlMB4XDTI0MDgxNjEyNTU1NVoX
DTM0MDgxNDEyNTU1NVowejELMAkGA1UEBhMCREUxEDAOBgNVBAcMB0ZyZWl0YWwx
DDAKBgNVBAoMA0JTSTEOMAwGA1UECwwFVEVNSVMxGTAXBgNVBAMMEGxkYXAudGVt
aXNsYWIuZGUxIDAeBgkqhkiG9w0BCQEWEXRlbWlzQGJzaS5idW5kLmRlMIICIjAN
BgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAjORFkPSgYe4CNffXaIfiF7f/kf4D
qgW60J+r0VW7lJCEh8N1HcB+FQ9i5kUvBBI9JokfRVMRafiDiBvaweP6wer1CahY
id2nCGHtfdS/jST+P094g/Q5jCMT2ahj/skNGlQEdQKzu//Y+yGRX0KmV0aq1wtX
X5OCJ7Dsidb+OgHBJsPPm7Z5ZH5oL8laV5utgEcT/KhO/4SLHygIDu7HEbPaToZr
jR3MnoKVOOUZHddZ2LvtygLuQj370p0/0FGqUoT4Sj4nTEQHoS4AASF1npwK0bqo
xNrB+oIo/mcl0pv1MurEQ3wrC+MbVezXXoxMgC81sByN4CY9V1HJV5vNbEuTNEyk
FBtGIGYy5+Sy8ADsU7nW5giXCHBg+b7tWyo/gOrmE4TssPz/rY5vOq7waEfCYdJD
SUB7OSacnvh1i922nPT3xpHHthmh2IGb1RWv/hw4qqDihZY2uQ5J8Vf2eJET44DZ
yOWw/ObbLbPxlpIKbUrPXjEhUwWJbdlzXc3epRvlMahler6HMd5KUpZ9ml6Zidyy
0wC9tTniCYdNWTkbNfIq4Abjft07K7F9b+FlFcft58P1OC932Lbt9oWVWplHkZEs
0khfcANx+UD3sWnHDfB0xmAfU1GaqB+oSLiOHsPnD00tMSbg70GMqi5kvC52J/44
wjBMzjKmBFH4EA8CAwEAAaNuMGwwSwYDVR0RBEQwQoIQbGRhcC50ZW1pc2xhYi5k
ZYIWbGRhcC1ub2RlMS50ZW1pc2xhYi5kZYIWbGRhcC1ub2RlMi50ZW1pc2xhYi5k
ZTAdBgNVHQ4EFgQUXZPUloFEFx6G1YUZR9yOE0NQ6YAwDQYJKoZIhvcNAQELBQAD
ggIBAHZJPytDcJheEe18NSN19KoDEmke2UnlF8fdBTsmeUqOKfGaNRu6VemUsu6M
OKy1yBuj6IoiAOUJowDFpz7+5rjb5zUepOidAh1LhphiavVLHziMPUq5ozKLBBRN
x2m5dtnBpX/9tG1uGOyI68KgGl+KsRUTjQtxlyGA7Qx5pAOt7RzzmThbyFk9idz/
J5cGyOeBK9BlJ0SMoEGBq7bgJlV5qTIcv4qswnPePrDd7AiRwX4w6fp+dl/FU1Gk
DyE7Yk5xxPQLHd/EaxcPFDRwRe1YaZhCTKhXT4N3eKLGr8VnJDcNmEnRKQ9uOZv0
tqt46Hz6zDbb45TSsFsKSDXVveJfgW3itKA9ICWkm3wjUfZskI0mzTAzesJBDQoj
hHUJGtdkqwpF9LsB8VXslmGnDwA2TvaMXS/9gKt99NfD+2k+3XtNy/FQwr/eFfqz
4kOsMJdi2u9ykmXTFbQ4DzKC7oDK8+RFKl8fY4b1wxvMcZ9Uwta5wxSIWDgLaDs4
6BOO4vgzyNVqGBeiRupDcQtgqWdkWa0zScMCRF4VYmdZjlWw7dp4/gy3PoAwK7Um
XTYB5FVMQcuG4xmlMCfXQSXu7SAqyDNYyVvByy9JOJv51GUNIk25lekdtZr2ImDV
X+2ovZNWWHr43755l2ruBpc5VrC8Fq93b9Whx0c94l+tsPKM
-----END CERTIFICATE-----
    ''
    # pwchange.temislab.de
    ''
      -----BEGIN CERTIFICATE-----
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
-----END CERTIFICATE-----
    ''
  ];
}
