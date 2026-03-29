{lib, config, ...}: let
  cfg = config.modules.services.system.navidrome;
in {
  options.modules.services.system.navidrome = {
    enable = lib.mkEnableOption "Navidrome";
    musicFolder = lib.mkOption {
      type = lib.types.either lib.types.str lib.types.path;
    };
  };

  config = lib.mkIf cfg.enable {
    services.navidrome = {
      enable = true;
      settings.MusicFolder = cfg.musicFolder;
    };

    systemd.services.navidrome.serviceConfig = {
      BindReadOnlyPaths = [
        cfg.musicFolder
      ];
    };
  };
}
