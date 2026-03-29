{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.programs.utility.dolphin;
in {
  options.modules.programs.utility.dolphin = {
    enable = lib.mkEnableOption "Dolphin";
  };

  config = lib.mkIf cfg.enable {
    hj.packages = [pkgs.kdePackages.dolphin];

    modules.desktops.hyprland.settings.bind = [
      "$mainMod, E, exec, ${lib.getExe' pkgs.kdePackages.dolphin "dolphin"}"
    ];
  };
}
