{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.programs.gaming.gamescope;
in {
  options.modules.programs.gaming.gamescope = {
    enable = lib.mkEnableOption "GameScope";
  };

  config = lib.mkIf cfg.enable {
    hj.packages = with pkgs; [gamescope-wsi];

    programs.gamescope = {
      enable = true;
      capSysNice = false;
    };
  };
}
