{
  lib,
  config,
  ...
}: {
  options.modules.services.system.radarr = {
    enable = lib.mkEnableOption "Radarr";
  };

  config = lib.mkIf config.modules.services.system.radarr.enable {
    services.radarr = {
      enable = true;
      openFirewall = true;
    };
  };
}
