{ config, lib, ... }:
{
  # this gives the option to allow unfree packages with simpler syntax and
  # in different parts of the config
  options.allowUnfreePackages = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
    description = "List of unfree packages to allow";
  };

  config.nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkg.pname or pkg.name or "") config.allowUnfreePackages;
}
