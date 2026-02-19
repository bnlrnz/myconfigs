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

  # since 25.11 this is kind of broken
  environment.systemPackages = with pkgs; [
    networkmanager-openconnect
  ];
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openconnect
  ];

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
MIIDFjCCApygAwIBAgIUF1TmYthu0kJaORTqPcyH4XuvKDMwCgYIKoZIzj0EAwQw
gbkxCzAJBgNVBAYTAkRFMQ8wDQYDVQQIDAZTYXhvbnkxEDAOBgNVBAcMB0ZyZWl0
YWwxPTA7BgNVBAoMNEJ1bmRlc2FtdCBmdWVyIFNpY2hlcmhlaXQgaW4gZGVyIElu
Zm9ybWF0aW9uc3RlY2huaWsxDjAMBgNVBAsMBVRFTUlTMRYwFAYDVQQDDA1URU1J
UyBSb290IENBMSAwHgYJKoZIhvcNAQkBFhF0ZW1pc0Bic2kuYnVuZC5kZTAeFw0y
MzA3MDMxMjQxMzZaFw0zMzA2MzAxMjQxMzZaMIG5MQswCQYDVQQGEwJERTEPMA0G
A1UECAwGU2F4b255MRAwDgYDVQQHDAdGcmVpdGFsMT0wOwYDVQQKDDRCdW5kZXNh
bXQgZnVlciBTaWNoZXJoZWl0IGluIGRlciBJbmZvcm1hdGlvbnN0ZWNobmlrMQ4w
DAYDVQQLDAVURU1JUzEWMBQGA1UEAwwNVEVNSVMgUm9vdCBDQTEgMB4GCSqGSIb3
DQEJARYRdGVtaXNAYnNpLmJ1bmQuZGUwdjAQBgcqhkjOPQIBBgUrgQQAIgNiAAQW
7uCygAm+cxyJxpfsHX2asI2MWzS3r+H2CHSHqbYKI+fdkqshk1RKKQIfHs9uD8Xs
oGLbqLPgTaq5dWufM1wxVEuLe76z/CXv3Bz5c/deTqaYlBFYDP3NYeK5To10TVCj
YzBhMB0GA1UdDgQWBBRP6LtKYef3ks0a8s3fcTvn4USXUjAfBgNVHSMEGDAWgBRP
6LtKYef3ks0a8s3fcTvn4USXUjAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQE
AwIBhjAKBggqhkjOPQQDBANoADBlAjAPdJq/UvbZuRR6DgVOdSXhrLNwwhe+GKSn
8y93XlAk9xblafZzIXM/t0F7I1dJ65YCMQCZ02S7H1DTSNkXUnhjTyEZ9YPojanG
C2w/T5Mu9fLr8G7ig39cUJTvR8YhDAq3ROU=
-----END CERTIFICATE-----
    ''
  ];
}
