{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.programs.vr.wivrn;
in {
  options.modules.programs.vr.wivrn = {
    enable = lib.mkEnableOption "WiVRn";
  };

  config = lib.mkIf cfg.enable {
    hj.packages = [pkgs.android-tools];

    services.wivrn = {
      enable = true;
      autoStart = true;
      config = {
        enable = true;
        json = {
          bitrate = 150000000;
          application = [
            (pkgs.writeShellScriptBin "wayvr-wrapper" "${lib.getExe pkgs.wayvr}")
          ];
        };
      };
    };
  };
}
