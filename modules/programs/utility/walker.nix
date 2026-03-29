{
  inputs,
  inputs',
  lib,
  config,
  ...
}: let
  cfg = config.modules.programs.utility.walker;
  walkerPkg = inputs'.walker.packages.default;
in {
  options.modules.programs.utility.walker = {
    enable = lib.mkEnableOption "Walker";
  };

  imports = [
    inputs.elephant.nixosModules.default
  ];

  disabledModules = ["services/misc/elephant.nix"];

  config = lib.mkIf cfg.enable {
    services.elephant = {
      enable = true;
      installService = false;
      providers = [
        "desktopapplications"
      ];
    };

    modules.desktops.hyprland.settings = {
      bind = [
        "$mainMod, R, exec, ${lib.getExe walkerPkg}"
      ];
      exec-once = [
        "${lib.getExe' inputs'.elephant.packages.default "elephant"}"
        "${lib.getExe walkerPkg} --gapplication-service"
      ];
    };

    hj = {
      packages = [walkerPkg];
    };
  };
}
