{
  inputs',
  lib,
  config,
  ...
}: let
  cfg = config.modules.core.tuigreet;
in {
  options.modules.core.tuigreet = {
    enable = lib.mkEnableOption "tuigreet";
    defaultCommand = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      inputs'.tuigreet.packages.tuigreet
    ];

    services.greetd = {
      enable = true;
      settings = {
        terminal.vt = 1;
        default_session = {
          command = "tuigreet --cmd ${cfg.defaultCommand}";
          user = "greeter";
        };
      };
    };
  };
}
