{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;

  cfg = config.modules.services.user.mpd;
in {
  options.modules.services.user.mpd = {
    enable = lib.mkEnableOption "mpd";
    musicDirectory = mkOption {
      type = types.either types.str types.path;
      default = config.hj.directory + "/Music";
    };
  };

  config = lib.mkIf cfg.enable {
    services.mpd = {
      enable = true;
      user = config.modules.core.user.username;

      settings = {
        music_directory = cfg.musicDirectory;
        audio_output = [
          {
            type = "pipewire";
            name = "PipeWire Output";
          }
        ];
      };
    };

    systemd.services.mpd.environment = {
      XDG_RUNTIME_DIR = "/run/user/1000";
    };
  };
}
