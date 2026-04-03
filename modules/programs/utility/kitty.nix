{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (config.modules.core) fonts;
  inherit (config.modules.desktops) common;

  cfg = config.modules.programs.utility.kitty;
in {
  options.modules.programs.utility.kitty = {
    enable = lib.mkEnableOption "Kitty";
  };

  config = lib.mkIf cfg.enable {
    hj = {
      packages = [pkgs.kitty];

      xdg.config.files."kitty/kitty.conf".text = ''
        font_family ${fonts.monospace.name}
        font_size 17

        background_opacity ${
          if common.style.enableTransparency
          then "0.65"
          else "1"
        }
        background_blur 1
        confirm_os_window_close 999
        default_pointer_shape arrow
        enable_audio_bell no

        initial_window_width 140c
        initial_window_height 35c
        remember_window_size no
        window_padding_width 8

        cursor_shape Underline
        cursor_underline_thickness 1

        foreground #bfc6ce
        background #101014
        cursor #f5f5f5
        cursor_text_color #a9b1d6
        selection_foreground #a9b1d6
        selection_background #22262e

        # Black
        color0 #1c252c
        color8 #384148

        # Red
        color1 #e05f65
        color9 #fc7b81

        # Green
        color2 #97D9AB
        color10 #97D9AB

        # Yellow
        color3 #f1cf8a
        color11 #ffeba6

        # Blue
        color4 #70a5eb
        color12 #b8b5fc

        # Magenta
        color5 #c68aee
        color13 #e2a6ff

        # Cyan
        color6 #74bee9
        color14 #90daff

        # White
        color7 #bfc6ce
        color15 #fafdff
      '';
    };

    modules.desktops = {
      hyprland.settings.bind = [
        "$mainMod, Q, exec, ${lib.getExe pkgs.kitty}"
      ];
      niri.binds = [
        ''Mod+Q { spawn "${lib.getExe pkgs.kitty}"; }''
      ];
    };
  };
}
