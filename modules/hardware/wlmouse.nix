{
  self',
  lib,
  config,
  ...
}: let
  cfg = config.modules.hardware.wlmouse;
in {
  options.modules.hardware.wlmouse = {
    enableUdevRules = lib.mkEnableOption "WLmouse Udev Rules";
  };

  config = {
    services.udev.packages = lib.mkIf cfg.enableUdevRules [
      self'.packages.wlmouse-udev-rules
    ];
  };
}
