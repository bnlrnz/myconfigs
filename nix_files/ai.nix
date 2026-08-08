# /etc/nixos/configuration.nix
{ config, pkgs, ... }:

{
  # Enable GPU acceleration and AMD graphics driver
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
 
  hardware.amdgpu.opencl.enable = true;

  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Grant your user rights to access direct rendering nodes
  users.users.ben.extraGroups = [ "video" "render" "docker" ];

  # System-wide ROCm execution context
  environment.sessionVariables = {
    # Targets the RDNA4 / gfx1201 target on RX 9070 XT
    HSA_OVERRIDE_GFX_VERSION = "12.0.1";
    # Mandatory for decent token/s throughput on llama-cpp ROCm
    GGML_CUDA_FORCE_MMQ = "ON";
    GGML_HIP_GRAPHS = "ON";
  };

  allowUnfreePackages = [ "lmstudio" "open-webui" ];

  # Packages
  environment.systemPackages = [
    # pkgs.open-webui
    pkgs.lmstudio
    pkgs.llama-cpp-rocm
    # CLI check tool to verify card detection
    pkgs.rocmPackages.rocminfo
    pkgs.rocmPackages.clr
  ];

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      rocmPackages.hipblas
      rocmPackages.rocblas
      rocmPackages.clr
    ];
  };
}
