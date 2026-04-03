{
  lib,
  config,
  self',
  ...
}: let
  cfg = config.modules.programs.web.surge;
in {
  options.modules.programs.web.surge = {
    enable = lib.mkEnableOption "Surge";
  };

  config = lib.mkIf cfg.enable {
    hj.packages = [self'.packages.surge];
  };
}
