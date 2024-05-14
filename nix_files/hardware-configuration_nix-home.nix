# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "nvme" "ahci" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/309eef6b-aa69-43be-b517-b1ac8024d4cc";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/3EB6-7D8C";
    fsType = "vfat";
  };

  fileSystems."/home/ben/Workspace" = {
    device = "/dev/disk/by-uuid/40627945-fa8a-45dc-bae0-3a65c8d75f01";
    fsType = "ext4";
  };

  fileSystems."/run/media/ben/Data_M2" = {
    device = "/dev/disk/by-label/Data_M2";
    fsType = "btrfs";
    options = [
      "noatime"
      "rw"
      "suid"
      "exec"
      "dev"
      "auto"
      "ssd"
      "nofail"
      "async"
    ];
  };

  # enable amd gpu drivers
  services.xserver.videoDrivers = ["amdgpu"];

  swapDevices =
    [{ device = "/dev/disk/by-uuid/8518e7e8-9dae-4c50-9d0f-852b1aae3895"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp39s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.opengl.extraPackages = [ pkgs.amdvlk ];
  hardware.opengl.extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];

  # steam only for home pc
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = 
      "\${HOME}/.steam/root/compatibilitytools.d";
  };
}
