{
  self,
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.desktops.hyprland.hypridle;
in {
  options.modules.desktops.hyprland.hypridle = {
    enable = lib.mkEnableOption "Hypridle";
    screenSleepDelay = lib.mkOption {
      type = lib.types.int;
      default = 300;
    };
  };

  config = lib.mkIf cfg.enable {
    hj = {
      xdg.config.files."hypr/hypridle.conf".text = self.lib.generators.toHyprconf {
        attrs = {
          listener = [
            {
              timeout = cfg.screenSleepDelay;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };

      systemd.services.hypridle = self.lib.services.mkGraphicalSessionService {
        description = "Hypridle";
        path = [pkgs.hypridle];
        execStart = lib.getExe pkgs.hypridle;
      };
    };
  };
}
