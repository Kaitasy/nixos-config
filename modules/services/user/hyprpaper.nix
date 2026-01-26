{
  self,
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.services.user.hyprpaper;
in {
  options.modules.services.user.hyprpaper = {
    enable = lib.mkEnableOption "Hyprpaper";
  };

  config = lib.mkIf cfg.enable {
    hj = {
      packages = [pkgs.hyprpaper];
      xdg.config.files = {
        "hypr/hyprpaper.conf" = {
          generator = self.lib.generators.toHyprlang {};
          value = {
            splash = 0;
            "wallpaper[]".path = "${config.modules.desktops.common.wallpaper}";
          };
        };
      };

      systemd.services.hyprpaper = self.lib.services.mkGraphicalSessionService {
        description = "Hyprpaper";
        path = [pkgs.hyprpaper];
        execStart = "${lib.getExe pkgs.hyprpaper}";
      };
    };
  };
}
