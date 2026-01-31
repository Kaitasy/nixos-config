{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.programs.gaming.prismlauncher;
in {
  options.modules.programs.gaming.prismlauncher = {
    enable = lib.mkEnableOption "PrismLauncher";
  };

  config = lib.mkIf cfg.enable {
    hj.packages = [pkgs.prismlauncher];
  };
}
