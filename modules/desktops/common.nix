{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types;
  cfg = config.modules.desktops.common;
in {
  options.modules.desktops.common = {
    wallpaper = mkOption {
      type = types.path;
    };

    style = {
      accentColor = mkOption {
        type = types.str;
        default = "b8b5fc";
        description = "Used for borders on tilers, launchers, dunst, etc.";
      };
      inactiveColor = mkOption {
        type = types.str;
        default = "30303c";
        description = "Used for borders on tilers, launchers, dunst, etc.";
      };
      enableTransparency = mkOption {
        type = types.bool;
        default = true;
        description = "Enable transparent background for certain programs";
      };
    };

    cursor = {
      name = mkOption {
        type = types.str;
        default = "Bibata-Modern-Classic";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.bibata-cursors;
      };
      size = mkOption {
        type = types.int;
        default = 24;
      };
    };

    input = {
      keyboardLayout = mkOption {
        type = types.str;
        default = "us";
      };
      sensitivity = mkOption {
        type = types.float;
        default = 0.0;
      };
    };

    monitors = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          description = mkOption {
            type = types.str;
            default = null;
            description = "Configure monitor using its description instead of output";
          };
          resolution = mkOption {
            type = types.str;
            example = "1920x1080";
            default = "1920x1080";
          };
          refreshRate = mkOption {
            type = types.int;
            default = 60;
          };
          scale = mkOption {
            type = types.float;
            default = 1.0;
          };
          x = mkOption {
            type = types.int;
            default = 0;
          };
          y = mkOption {
            type = types.int;
            default = 0;
          };

          cm = {
            primaries = mkOption {
              type = types.enum [
                "srgb"
                "wide"
                "hdr"
              ];
              default = "srgb";
            };
            bitdepth = mkOption {
              type = types.int;
              default = 8;
            };
          };
        };
      });
      default = {};
    };
  };

  config = {
    hj = {
      # Common packages
      packages = with pkgs;
        [
          wl-clipboard
          nh
          curl
          openssh
          eza
          zoxide
          bat
          less

          gnome-keyring
          libsecret
        ]
        ++ [cfg.cursor.package];

      xdg.data.files."icons/default/index.theme" = {
        generator = lib.generators.toINI {};
        value = {
          "Icon Theme".Inherits = cfg.cursor.name;
        };
      };
    };

    services.dbus.implementation = "broker";

    # Required for some programs like Matrix clients and Trucky
    # + Good to have
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.login.enableGnomeKeyring = true;

    environment.sessionVariables = {
      XCURSOR_THEME = cfg.cursor.name;
      XCURSOR_SIZE = cfg.cursor.size;
      XCURSOR_PATH = ["${cfg.cursor.package}/share/icons"];
    };
  };
}
