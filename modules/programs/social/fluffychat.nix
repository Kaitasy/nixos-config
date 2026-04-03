{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.programs.social.fluffychat;
in {
  options.modules.programs.social.fluffychat = {
    enable = lib.mkEnableOption "FluffyChat";
  };

  config = lib.mkIf cfg.enable {
    hj.packages = [pkgs.fluffychat];
  };
}
