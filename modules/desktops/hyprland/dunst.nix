{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (config.modules.desktops) common;
  inherit (config.modules.core) fonts;
  cfg = config.modules.desktops.hyprland.dunst;
in {
  options.modules.desktops.hyprland.dunst = {
    enable = lib.mkEnableOption "Dunst";
  };

  config = lib.mkIf cfg.enable {
    modules.desktops.hyprland.settings = {
      exec-once = ["${lib.getExe pkgs.dunst} -conf ~/.config/dunst/dunstrc"];
      layerrule = [
        "blur on, match:namespace notifications"
        "ignore_alpha 0.6, match:namespace notifications"
      ];
    };

    hj = {
      packages = [pkgs.dunst];

      xdg.config.files."dunst/dunstrc" = {
        generator = lib.generators.toINI {};
        value = {
          global = {
            origin = "top-center";
            offset = "(0, 0)";
            width = "(100, 500)";
            height = "(0, 300)";
            notification_limit = 3;
            corner_radius = 8;
            padding = 10;
            frame_width = 2;
            gap_size = 6;
            font = "${fonts.monospace.name} 14";
          };

          urgency_low = {
            # INI is a fucking retarded format and so is dunst's parser
            background = "\"#121212a5\"";
            foreground = "\"#bfc6ce\"";
            highlight = "\"#${common.style.accentColor}\"";
            timeout = 5;
          };

          urgency_normal = {
            background = "\"#121212a5\"";
            foreground = "\"#bfc6ce\"";
            frame_color = "\"#${common.style.accentColor}\""; # idk what the difference between the two is maybe i should read the docs
            highlight = "\"#${common.style.accentColor}\"";
            timeout = 5;
          };

          urgency_critical = {
            background = "\"#121212a5\"";
            foreground = "\"#bfc6ce\"";
            frame_color = "\"#fc7b81\"";
            highlight = "\"#d54e53\"";
            timeout = 0;
          };
        };
      };
    };
  };
}
