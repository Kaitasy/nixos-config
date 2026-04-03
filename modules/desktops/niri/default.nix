{
  lib,
  config,
  pkgs,
  inputs',
  ...
}: let
  cfg = config.modules.desktops.niri;
  inherit (config.modules.desktops) common;

  package =
    if cfg.useWipBranch
    then inputs'.niri.packages.default
    else pkgs.niri;
in {
  options.modules.desktops.niri = {
    enable = lib.mkEnableOption "Niri";
    useWipBranch = lib.mkEnableOption "WIP Branch";

    # Should be the only things needed to be configurable from outside this module
    # Cursed be the person who thought KDL is a good config format
    binds = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
    };
    spawnShAtStartup = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
    };
    spawnAtStartup = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
    };
    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.niri = {
      inherit package;
      enable = true;
    };

    modules.desktops.niri = {
      spawnShAtStartup = [
        "dbus-update-activation-environment --systemd --all"
        "systemctl --user start niri-session.target"
      ];

      binds =
        [
          "Mod+C       { close-window; }"
          "Mod+F       { maximize-column; }"
          "Mod+Shift+F { fullscreen-window; }"
          "Mod+X       { toggle-window-floating; }"
          "Mod+D       { switch-preset-column-width; }"
          "Mod+V       { center-visible-columns; }"
          "Alt+Tab     { toggle-overview; }"

          "Mod+Left  { focus-column-left; }"
          "Mod+Down  { focus-window-down; }"
          "Mod+Up    { focus-window-up; }"
          "Mod+Right { focus-column-right; }"
          "Mod+Shift+WheelScrollUp   cooldown-ms=100 { focus-column-left; }"
          "Mod+Shift+WheelScrollDown cooldown-ms=100 { focus-column-right; }"

          "Mod+Ctrl+Left  { move-column-left; }"
          "Mod+Ctrl+Down  { move-window-down; }"
          "Mod+Ctrl+Up    { move-window-up; }"
          "Mod+Ctrl+Right { move-column-right; }"

          "Mod+WheelScrollDown cooldown-ms=100 { focus-workspace-down; }"
          "Mod+WheelScrollUp   cooldown-ms=100 { focus-workspace-up; }"

          "Mod+BracketLeft  { consume-or-expel-window-left; }"
          "Mod+BracketRight { consume-or-expel-window-right; }"

          "Mod+Minus { set-column-width \"-10%\"; }"
          "Mod+Equal { set-column-width \"+10%\"; }"

          "Mod+Shift+P { power-off-monitors; }"
        ]
        ++ builtins.map (idx: "Mod+${toString (
          if idx == 10
          then 0
          else idx
        )} { focus-workspace ${toString idx}; }") (lib.range 1 10)
        ++ builtins.map (idx: "Mod+Shift+${toString (
          if idx == 10
          then 0
          else idx
        )} { move-column-to-workspace ${toString idx}; }") (lib.range 1 10);
    };

    modules.services.user.hyprpaper.enable = lib.mkDefault true;

    hj = {
      xdg.config.files."niri/config.kdl".text = let
        outputs =
          builtins.map (output: let
            settings = common.monitors.${output};
          in ''
            output "${output}" {
              mode "${settings.resolution}@${toString settings.refreshRate}"
              scale ${toString settings.scale}
              position x=${toString settings.x} y=${toString settings.y}
              variable-refresh-rate
            }
          '')
          (builtins.attrNames common.monitors);

        sh-startup = builtins.map (x: "spawn-sh-at-startup \"${x}\"") cfg.spawnShAtStartup;
        startup = builtins.map (x: "spawn-at-startup \"${x}\"") cfg.spawnAtStartup;
      in
        ''
          ${builtins.concatStringsSep "\n" outputs}
          ${builtins.concatStringsSep "\n" sh-startup}
          ${builtins.concatStringsSep "\n" startup}

          prefer-no-csd

          input {
            keyboard {
              xkb {
                layout "${common.input.keyboardLayout}"
              }
            }

            mouse {
              accel-speed ${toString common.input.sensitivity}
              accel-profile "flat"
            }

            focus-follows-mouse
          }

          layout {
            gaps 8
            center-focused-column "never"
            background-color "transparent"

            preset-column-widths {
              proportion 0.3333333
              proportion 0.5
              proportion 0.6666667
            }

            default-column-width { proportion 0.5; }

            focus-ring {
              off
            }

            border {
              on
              width 2
              active-color "${common.style.accentColor}"
              inactive-color "${common.style.inactiveColor}"
            }

            shadow {
              on
              softness 30
              spread 4
              color "#00000044"
            }

            struts {
              left 8
              right 8
              top 8
              bottom 8
            }
          }

          cursor {
            xcursor-theme "${common.cursor.name}"
            xcursor-size ${toString common.cursor.size}
          }

          overview {
            zoom 0.5
          }

          xwayland-satellite {
            path "${lib.getExe pkgs.xwayland-satellite}"
          }

          clipboard {
            disable-primary
          }

          binds {
            ${builtins.concatStringsSep "\n" cfg.binds}
          }
        ''
        + lib.optionalString cfg.useWipBranch
        ''
          blur {
            passes 3
            offset 2
            noise 0.1
            saturation 1
          }
        ''
        + lib.optionalString (cfg.extraConfig != "") cfg.extraConfig;
    };

    systemd.user.targets.niri-session = {
      description = "Niri session";
      bindsTo = ["graphical-session.target"];
      wants = ["graphical-session-pre.target"];
      after = ["graphical-session-pre.target"];
    };

    xdg.portal.config.niri.default = [
      "gnome"
      "gtk"
    ];
  };
}
