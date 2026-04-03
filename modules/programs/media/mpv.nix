{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.programs.media.mpv;
in {
  options.modules.programs.media.mpv = {
    enable = lib.mkEnableOption "mpv";
  };

  config = lib.mkIf cfg.enable {
    hj.packages = [
      (pkgs.mpv.override {
        scripts = with pkgs; [
          mpvScripts.mpris
        ];
      })
    ];

    xdg.mime.defaultApplications = builtins.listToAttrs (builtins.map (schema: {
        name = schema;
        value = "mpv.desktop";
      }) [
        "video/mp4"
        "video/x-matroska"
        "video/webm"
        "audio/mpeg"
        "audio/flac"
        "audio/wav"
        "audio/aac"
      ]);
  };
}
