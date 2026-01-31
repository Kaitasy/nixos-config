{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.programs.virtualization.winboat;
in {
  options.modules.programs.virtualization.winboat = {
    enable = lib.mkEnableOption "Winboat";
  };

  config = lib.mkIf cfg.enable {
    # Ensure docker is enabled
    modules.services.system.docker.enable = lib.mkForce true;

    hj.packages = with pkgs; [
      winboat
      freerdp
    ];
  };
}
