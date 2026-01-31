{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.services.system.docker;
in {
  options.modules.services.system.docker = {
    enable = lib.mkEnableOption "Docker";
    addUserToGroup = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Add default user to the docker group";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
    };

    environment.systemPackages = with pkgs; [
      docker-compose
    ];

    users.users.${config.modules.core.user.username}.extraGroups = ["docker"];
  };
}
