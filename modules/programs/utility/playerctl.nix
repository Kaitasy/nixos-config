{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.programs.utility.playerctl;
  exe = lib.getExe pkgs.playerctl;
in {
  options.modules.programs.utility.playerctl = {
    enable = lib.mkEnableOption "playerctl";
  };

  config = lib.mkIf cfg.enable {
    modules.desktops = {
      hyprland.settings.bindl = [
        ", XF86AudioNext, exec, ${exe} next"
        ", XF86AudioPrev, exec, ${exe} previous"
        ", XF86AudioPlay, exec, ${exe} play-pause"
        ", XF86AudioPause, exec, ${exe} play-pause"
      ];
      niri.binds = [
        "XF86AudioNext { spawn-sh \"${exe} next\"; }"
        "XF86AudioPrev { spawn-sh \"${exe} previous\"; }"
        "XF86AudioPlay { spawn-sh \"${exe} play-pause\"; }"
        "XF86AudioPause { spawn-sh \"${exe} play-pause\"; }"
      ];
    };
  };
}
