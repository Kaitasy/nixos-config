{
  lib,
  config,
  ...
}: let
  cfg = config.modules.core.networking;
in {
  options.modules.core.networking = {
    hostname = lib.mkOption {
      type = lib.types.str;
    };
    enableNetworkManager = lib.mkEnableOption "Use NetworkManager instead of systemd-networkd";
  };

  config.networking = {
    hostName = cfg.hostname;
    networkmanager.enable = cfg.enableNetworkManager;
    useNetworkd = !cfg.enableNetworkManager;
  };
}
