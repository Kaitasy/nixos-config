{
  lib,
  config,
  ...
}: {
  options.modules.services.system.prowlarr = {
    enable = lib.mkEnableOption "Prowlarr";
  };

  config = lib.mkIf config.modules.services.system.prowlarr.enable {
    services.prowlarr = {
      enable = true;
      openFirewall = true;
    };
  };
}
