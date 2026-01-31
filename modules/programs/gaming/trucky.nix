{
  self',
  lib,
  config,
  ...
}: let
  cfg = config.modules.programs.gaming.trucky;
in {
  options.modules.programs.gaming.trucky = {
    enable = lib.mkEnableOption "Trucky";
  };

  config = lib.mkIf cfg.enable {
    hj.packages = [self'.packages.trucky];

    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  };
}
