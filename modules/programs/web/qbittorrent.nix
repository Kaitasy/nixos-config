{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.programs.web.qbittorrent;
in {
  options.modules.programs.web.qbittorrent = {
    enable = lib.mkEnableOption "qBittorrent";
  };

  config = lib.mkIf cfg.enable {
    hj.packages = [pkgs.qbittorrent];
  };
}
