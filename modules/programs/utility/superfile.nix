{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.programs.utility.superfile;
in {
  options.modules.programs.utility.superfile = {
    enable = lib.mkEnableOption "Superfile";
  };

  config = lib.mkIf cfg.enable {
    hj = {
      packages = [pkgs.superfile];

      xdg.config.files."superfile/config.toml".text = ''
        transparent_background = true
      '';
    };

    modules.desktops.hyprland.settings.bind = [
      "$mainMod, E, exec, ${lib.getExe pkgs.kitty} ${lib.getExe pkgs.superfile}"
    ];
  };
}
