{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.services.system.mullvad;

  mullvadConfig = pkgs.writeText "mullvad-settings" (
    builtins.toJSON {
      allow_lan = cfg.allowLan;
      auto_connect = cfg.autoConnect;
      relay_settings.normal.location.only.location.country = cfg.relayLocation;
    }
  );
in {
  options.modules.services.system.mullvad = {
    enable = lib.mkEnableOption "Mullvad VPN";
    allowLan = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    autoConnect = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    relayLocation = lib.mkOption {
      type = lib.types.str;
      default = "de";
    };
  };

  config = lib.mkIf cfg.enable {
    services.mullvad-vpn.enable = true;

    # From https://wiki.nixos.org/wiki/Mullvad_VPN
    systemd = {
      services."mullvad-daemon".environment.MULLVAD_SETTINGS_DIR = "/var/lib/mullvad-vpn";

      tmpfiles.settings."10-mullvad-settings"."/var/lib/mullvad-vpn/settings.json"."C+" = {
        user = "root";
        group = "root";
        mode = "0700";
        argument = "${mullvadConfig}";
      };
    };
  };
}
