{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.programs.gaming.steam;
in {
  options.modules.programs.gaming.steam = {
    enable = lib.mkEnableOption "Steam";
  };

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      protontricks.enable = true;
      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
    };

    modules.desktops.niri.extraConfig = ''
      window-rule {
        match app-id="steam" title=r#"^notificationtoasts_\d+_desktop$"#
        default-floating-position x=8 y=8 relative-to="bottom-right"
      }
    '';
  };
}
