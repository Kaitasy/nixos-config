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
    };
    systemd.services.sonarr.serviceConfig = {
      PrivateUsers = lib.mkForce false;
      SystemCallFilter = lib.mkForce [
        "@system-service"
        "~@privileged"
        "~@debug"
        "~@mount"
        "@chown"
        "linkat" # explicitly allow
      ];
    };
  };
}
