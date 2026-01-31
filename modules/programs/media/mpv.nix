{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.programs.media.mpv;
in {
  options.modules.programs.media.mpv = {
    enable = lib.mkEnableOption "mpv";
  };

  config = lib.mkIf cfg.enable {
    hj.packages = [pkgs.mpv];
  };
}
