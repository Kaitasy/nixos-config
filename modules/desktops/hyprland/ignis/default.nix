{
  pkgs,
  inputs',
  lib,
  config,
  ...
}: let
  cfg = config.modules.desktops.hyprland.ignis;
  pkg =
    inputs'.ignis.packages.default.override
    {
      enableNetworkService = true;
      useDartSass = true;
      extraPackages = with pkgs; [
        python313Packages.psutil
      ];
    };
in {
  options.modules.desktops.hyprland.ignis = {
    enable = lib.mkEnableOption "Ignis";
  };

  config = lib.mkIf cfg.enable {
    hj = {
      packages = [pkg];

      xdg.config.files = {
        "ignis/hypr/config.py".source = ./config.py;
        "ignis/hypr/style.scss".source = ./style.scss;
        "ignis/hypr/utils.py".source = ./utils.py;
        "ignis/hypr/modules".source = ./modules;
        "ignis/hypr/widgets".source = ./widgets;
      };
    };

    fonts.packages = [
      pkgs.font-awesome
    ];

    modules.desktops.hyprland.settings = {
      exec-once = [
        "${lib.getExe pkg} init -c ~/.config/ignis/hypr/config.py"
      ];
      layerrule = [
        "blur on, blur_popups true, ignore_alpha 0.6, match:namespace shell-bar-\\d+"
      ];
    };
  };
}
