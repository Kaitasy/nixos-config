{
  lib,
  config,
  ...
}: {
  options.modules.services.system.sonarr = {
    enable = lib.mkEnableOption "Sonarr";
  };

  config = lib.mkIf config.modules.services.system.sonarr.enable {
    services.sonarr = {
      enable = true;
      openFirewall = true;
    };
  };
}
