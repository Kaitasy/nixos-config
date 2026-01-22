{
  self,
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.programs.wayland.hyprpaper;
in {
  options.modules.programs.wayland.hyprpaper = {
    enable = lib.mkEnableOption "Hyprpaper";
  };

  config = lib.mkIf cfg.enable {
    modules.desktops.hyprland.settings.exec-once = ["${lib.getExe pkgs.hyprpaper}"];

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
    };
  };
}
