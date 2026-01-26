{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
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
    # Common packages
    hj.packages = with pkgs; [
      wl-clipboard
      nh
      curl
      openssh
      eza
      zoxide
    ];

    services.dbus.implementation = "broker";
  };
}
