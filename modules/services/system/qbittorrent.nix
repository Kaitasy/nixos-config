{
  lib,
  config,
  ...
}: {
  options.modules.services.system.qbittorrent = {
    enable = lib.mkEnableOption "qBittorrent";
  };

  config = lib.mkIf config.modules.services.system.qbittorrent.enable {
    services.qbittorrent = {
      enable = true;
      openFirewall = true;
      group = config.modules.core.user.username;
    };

    systemd.services.qbittorrent.serviceConfig.UMask = "0002";
  };
}
