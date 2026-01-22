{
  lib,
  config,
  ...
}: let
  cfg = config.modules.core.pipewire;
in {
  options.modules.core.pipewire = {
    enable = lib.mkEnableOption "Enable PipeWire sound server";
    lowLatency = lib.mkOption {
      type = lib.types.bool;
      description = "Configure PipeWire and ALSA for minimal latency";
    };
  };

  config = lib.mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      audio.enable = true;
      wireplumber.enable = true;
      pulse.enable = true;
      alsa.enable = true;
      jack.enable = true;

      # TODO: Add low latency config
    };
  };
}
