{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.programs.utility.btop;
in {
  options.modules.programs.utility.btop = {
    enable = lib.mkEnableOption "btop";
  };

  config = lib.mkIf cfg.enable {
    hj = {
      packages = [pkgs.btop];

      xdg.config.files."btop/btop.conf".text = ''
        color_theme = "TTY"
        theme_background = False
      '';
    };

    modules.desktops.hyprland.settings.bind = [
      "$mainMod, T, exec, ${lib.getExe pkgs.kitty} ${lib.getExe pkgs.btop}"
    ];
  };
}
