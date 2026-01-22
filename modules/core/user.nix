{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.core.user;
in {
  options.modules.core.user = {
    username = lib.mkOption {
      type = lib.types.str;
      default = "user";
    };
  };

  imports = [
    inputs.hjem.nixosModules.default
    (lib.modules.mkAliasOptionModule ["hj"] ["hjem" "users" cfg.username])
  ];

  config = {
    hjem = {
      linker = pkgs.smfh;
      clobberByDefault = true;
      users.${cfg.username} = {
        user = cfg.username;
        systemd.enable = true;
      };
    };

    users.users.${cfg.username} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "input"
        "video"
      ];
      initialPassword = "1234";
    };
  };
}
