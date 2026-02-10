{
  self,
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.services.user.jellyfin-mpv-shim;
in {
  options.modules.services.user.jellyfin-mpv-shim = {
    enable = lib.mkEnableOption "Jellyfin MPV Shim";
  };

  config = lib.mkIf cfg.enable {
    hj = {
      packages = [pkgs.jellyfin-mpv-shim];

      systemd.services.jellyfin-mpv-shim = self.lib.services.mkGraphicalSessionService {
        description = "Jellyfin MPV Shim";
        path = [pkgs.jellyfin-mpv-shim];
        execStart = lib.getExe pkgs.jellyfin-mpv-shim;
      };
    };
  };
}
