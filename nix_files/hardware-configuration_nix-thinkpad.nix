# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "usb_storage"
    "sd_mod"
    #"acpi" currently missing in 6.8.6
    "acpi_call"
    "thinkpad-acpi"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "acpi_call" "i915" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.acpi_call ];

  boot.kernelParams = [
    # Force use of the thinkpad_acpi driver for backlight control.
    # This allows the backlight save/load systemd service to work.
    "acpi_backlight=native"

    # laptop open/close
    "button.lid_init_state=open"
  ];

  # intel internal gpu driver
  environment.variables = {
    VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
  };

  hardware.opengl.extraPackages = with pkgs; [
    (if (lib.versionOlder (lib.versions.majorMinor lib.version) "23.11") then vaapiIntel else intel-vaapi-driver)
    libvdpau-va-gl
    intel-media-driver
  ];

  # lid close battery
  services.logind.lidSwitch = "suspend";

  # lid close on dock
  services.logind.lidSwitchDocked = "ignore";

  # trim command ssd
  services.fstrim.enable = lib.mkDefault true;

  boot.initrd.luks.devices."luks-49f4f24c-6e57-48de-8f8c-ed9d206907b4".device =
    "/dev/disk/by-uuid/49f4f24c-6e57-48de-8f8c-ed9d206907b4";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/635576ff-abd4-4252-86df-c2ed30a0830c";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-53f725a7-a224-4a24-9870-24f1f0507458".device =
    "/dev/disk/by-uuid/53f725a7-a224-4a24-9870-24f1f0507458";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0403-2F64";
    fsType = "vfat";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/f3396652-0c39-4db7-850e-55a3cedac667"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;
  # networking.interfaces.wwp0s20f0u2.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
  #hardware.pulseaudio.enable = true;
  #hardware.pulseaudio.support32Bit = true;
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot =
    true; # powers up the default Bluetooth controller on boot

  # thinkpad trackball
  hardware.trackpoint.enable = lib.mkDefault true;
  hardware.trackpoint.emulateWheel =
    lib.mkDefault config.hardware.trackpoint.enable;

  # laptop power management
  powerManagement.enable = true;
  services.thermald.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 50;

      #Optional helps save long term battery health
      START_CHARGE_THRESH_BAT0 = 90; # 40 and bellow it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 98; # 80 and above it stops charging
    };
  };
}
