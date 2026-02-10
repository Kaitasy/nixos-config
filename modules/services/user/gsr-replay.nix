{
  self,
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types;

  cfg = config.modules.services.user.gsr-replay;
in {
  options.modules.services.user.gsr-replay = {
    enable = lib.mkEnableOption "GPU Screen Recorder Replay";
    video = {
      source = mkOption {
        type = types.str;
        default = "portal";
        description = "Anything except 'portal' requires root permissions";
      };
      container = mkOption {
        type = types.enum [
          "mkv"
          "mp4"
          "webm"
          "flv"
        ];
        default = "mkv";
      };
      framerate = mkOption {
        type = types.int;
        default = 60;
      };
      codec = mkOption {
        type = types.enum [
          "h264"
          "hevc"
          "av1"
          "vp8"
          "vp9"
          "hevc_hdr"
          "av1_hdr"
          "hevc_10bit"
          "av1_10bit"
        ];
        default = "h264";
      };
      encoder = mkOption {
        type = types.enum [
          "gpu"
          "cpu"
        ];
        default = "gpu";
      };
      bitrate = mkOption {
        type = types.int;
        default = 6000;
      };
    };
    audio = {
      sources = mkOption {
        type = types.listOf types.str;
        default = [
          "default_output"
        ];
        example = [
          "default_input"
          "device:MyAwesomeAudioDevice"
          "app-inverse:Spotify"
        ];
      };
      codec = mkOption {
        type = types.enum [
          "aac"
          "opus"
        ];
        default = "aac";
      };
      bitrate = mkOption {
        type = types.int;
        default = 160;
      };
    };
    replay = {
      duration = mkOption {
        type = types.int;
        default = 60;
        description = "Replay buffer duration in seconds";
      };
      storage = mkOption {
        type = types.enum [
          "ram"
          "disk"
        ];
        default = "ram";
      };
      restartOnSave = mkOption {
        type = types.bool;
        default = false;
      };
      outputDirectory = mkOption {
        type = types.either types.str types.path;
        default = config.hj.directory + "/Videos";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    hj.systemd.services.gsr-replay = self.lib.services.mkGraphicalSessionService {
      description = "GPU Screen Recorder Replay";
      path = [pkgs.gpu-screen-recorder];
      execStart = let
        inherit (cfg) video audio replay;
        boolToString = v:
          if v
          then "yes"
          else "no";

        audioSources = lib.concatMapStringsSep " " (a: ''-a "${a}"'') cfg.audio.sources;
      in "${lib.getExe pkgs.gpu-screen-recorder} -w ${video.source} -restore-portal-session yes -c ${video.container} -k ${video.codec} -f ${toString video.framerate} ${audioSources} -q ${toString video.bitrate} -bm cbr -encoder ${video.encoder} -ac ${audio.codec} -ab ${toString audio.bitrate} -r ${toString replay.duration} -replay-storage ${replay.storage} -restart-replay-on-save ${boolToString replay.restartOnSave} -o ${replay.outputDirectory}";
    };
  };
}
