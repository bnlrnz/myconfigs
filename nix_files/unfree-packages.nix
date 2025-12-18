{ config, lib, ... }:
{
  options.allowUnfreePackages = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
    description = "List of unfree packages to allow";
  };

  config.nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkg.pname or pkg.name or "") config.allowUnfreePackages;
}
