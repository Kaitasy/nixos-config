{
  lib,
  config,
  ...
}: let
  cfg = config.modules.services.system.jellyfin;
in {
  options.modules.services.system.jellyfin = {
    enable = lib.mkEnableOption "Jellyfin";
  };

  config = lib.mkIf cfg.enable {
    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };
    users.users.jellyfin.extraGroups = ["video" "render"];
  };
}
