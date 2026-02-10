{
  self',
  lib,
  config,
  ...
}: let
  cfg = config.modules.programs.gaming.truckersmp-cli;
in {
  options.modules.programs.gaming.truckersmp-cli = {
    enable = lib.mkEnableOption "TruckersMP CLI";
  };

  config = lib.mkIf cfg.enable {
    hj.packages = [self'.packages.truckersmp-cli];
  };
}
