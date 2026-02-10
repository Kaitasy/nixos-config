{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.programs.gaming.bs-manager;
in {
  options.modules.programs.gaming.bs-manager = {
    enable = lib.mkEnableOption "BSManager";
  };

  config = lib.mkIf cfg.enable {
    hj.packages = [pkgs.bs-manager];

    xdg.mime.defaultApplications = {
      "x-scheme-handler/modelsaber" = "BSManager.desktop";
      "x-scheme-handler/beatsaver" = "BSManager.desktop";
      "x-scheme-handler/bsplaylist" = "BSManager.desktop";
      "x-scheme-handler/web+bsmap" = "BSManager.desktop";
      "x-scheme-handler/bsmanager" = "BSManager.desktop";
    };
  };
}
