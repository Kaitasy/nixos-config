{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.programs.utility.pwvucontrol;
in {
  options.modules.programs.utility.pwvucontrol = {
    enable = lib.mkEnableOption "pwvucontrol";
  };

  config = lib.mkIf cfg.enable {
    hj.packages = [pkgs.pwvucontrol];
  };
}
