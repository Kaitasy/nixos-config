{
  inputs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.programs.web.schizofox;
in {
  options.modules.programs.web.schizofox = {
    enable = lib.mkEnableOption "Schizofox";
  };

  imports = [
    inputs.schizofox.nixosModules.default
  ];

  config = lib.mkIf cfg.enable {
    programs.schizofox = {
      enable = true;

      extensions = {
        enableDefaultExtensions = true;
        simplefox.enable = true;
        darkreader.enable = true;
      };
    };
  };
}
