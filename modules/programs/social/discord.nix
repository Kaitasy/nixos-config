{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.programs.social.discord;
in {
  options.modules.programs.social.discord = {
    enable = lib.mkEnableOption "Discord";
  };

  config = lib.mkIf cfg.enable {
    hj.packages = [
      # (pkgs.discord.override {
      #   withOpenASAR = true;
      #   withVencord = true;
      # })
      pkgs.vesktop
    ];
  };
}
