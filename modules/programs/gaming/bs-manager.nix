{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.programs.gaming.bs-manager;
in {
  options.modules.programs.gaming.bs-manager = {
    enable = lib.mkEnableOption "BSManager";
  };

  config = lib.mkIf cfg.enable {
    hj.packages = [pkgs.bs-manager];
  };
}
