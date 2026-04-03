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

        xdg.config.files."nushell/config.nu".text = ''
          $env.config.show_banner = false
          $env.config.buffer_editor = "nvim"
        '';
      };
    };

    users.users.${cfg.username} = {
      group = cfg.username;
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "input"
        "video"
      ];
      initialPassword = "1234";
      uid = 1000;
      shell = pkgs.nushell;
    };
    users.groups.${cfg.username} = {};

    programs = {
      # fish = {
      #   enable = true;
      #   shellInit = "set -u fish_greeting";
      #   promptInit = ''
      #     ${lib.getExe pkgs.starship} init fish | source
      #     zoxide init fish | source
      #   '';
      #   shellAliases = {
      #     ls = "${lib.getExe pkgs.eza} --icons -hS";
      #   };
      # };
      zsh = {
        enable = true;
        shellAliases = {
          ls = "${lib.getExe pkgs.eza} --icons -hS";
        };
        ohMyZsh = {
          enable = true;
          plugins = [
            "git"
            "rust"
          ];
          theme = "robbyrussell";
        };
      };
    };
  };
}
