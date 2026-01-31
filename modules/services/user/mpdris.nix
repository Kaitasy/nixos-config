{
  self,
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.services.user.mpdris;
in {
  options.modules.services.user.mpdris = {
    enable = lib.mkEnableOption "MPDRIS";
  };

  config = lib.mkIf cfg.enable {
    hj.systemd.services.mpdris = self.lib.services.mkGraphicalSessionService {
      description = "mpdris2 service";
      path = [pkgs.mpdris2];
      execStart = lib.getExe pkgs.mpdris2;
    };
  };
}
