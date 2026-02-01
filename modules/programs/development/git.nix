{
  lib,
  config,
  ...
}: let
  cfg = config.modules.programs.development.git;
in {
  options.modules.programs.development.git = {
    enable = lib.mkEnableOption "Git";
  };

  config = lib.mkIf cfg.enable {
    programs.git.enable = true;
  };
}
