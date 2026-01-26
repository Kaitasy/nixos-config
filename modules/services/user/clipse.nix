{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.services.user.clipse;
in {
  options.modules.services.user.clipse = {
    enable = lib.mkEnableOption "Clipse";
  };

  config = lib.mkIf cfg.enable {
    hj = {
      packages = [pkgs.clipse];
      # TODO: Configure clipse and add keybinds for desktops
    };
  };
}
