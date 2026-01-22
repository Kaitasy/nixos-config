{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.programs.utility.kitty;
in {
  options.modules.programs.utility.kitty = {
    enable = lib.mkEnableOption "Kitty";
  };

  config = lib.mkIf cfg.enable {
    hj = {
      packages = [pkgs.kitty];
    };

    modules.desktops.hyprland.settings.bind = [
      "$mainMod, Q, exec, ${lib.getExe pkgs.kitty}"
    ];
  };
}
