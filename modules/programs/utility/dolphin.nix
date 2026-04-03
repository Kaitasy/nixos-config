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
    hj.packages = with pkgs; [
      kdePackages.dolphin
      kdePackages.dolphin-plugins
      kdePackages.ark
      p7zip
      unrar
    ];

    services.udisks2.enable = true;

    environment.etc."xdg/menus/applications.menu".source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

    modules.desktops.hyprland.settings.bind = [
      "$mainMod, E, exec, ${lib.getExe' pkgs.kdePackages.dolphin "dolphin"}"
    ];
  };
}
