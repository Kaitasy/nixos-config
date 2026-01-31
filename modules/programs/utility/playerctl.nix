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
    modules.desktops.hyprland.settings.bindl = [
      ", XF86AudioNext, exec, ${exe} next"
      ", XF86AudioPrev, exec, ${exe} previous"
      ", XF86AudioPlay, exec, ${exe} play-pause"
      ", XF86AudioPause, exec, ${exe} play-pause"
    ];
  };
}
