{
  lib,
  config,
  ...
}: let
  cfg = config.modules.programs.gaming.gamemode;
in {
  options.modules.programs.gaming.gamemode = {
    enable = lib.mkEnableOption "GameMode";
  };

  config = lib.mkIf cfg.enable {
    programs.gamemode.enable = true;
  };
}
