{pkgs, lib, config, ...}: let
  cfg = config.modules.programs.media.feishin;
in {
  options.modules.programs.media.feishin = {
    enable = lib.mkEnableOption "Feishin";
  };

  config = lib.mkIf cfg.enable {
    hj.packages = [pkgs.feishin];
  };
}
