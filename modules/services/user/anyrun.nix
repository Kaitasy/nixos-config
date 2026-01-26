{
  self,
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.services.user.anyrun;
in {
  options.modules.services.user.anyrun = {
    enable = lib.mkEnableOption "Anyrun Daemon";
  };

  config = lib.mkIf cfg.enable {
    hj.systemd.services.anyrun-daemon = self.lib.services.mkGraphicalSessionService {
      description = "Anyrun Daemon";
      path = [pkgs.anyrun];
      execStart = "${lib.getExe pkgs.anyrun} daemon";
    };
  };
}
