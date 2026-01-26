{
  self,
  pkgs,
  inputs,
  lib,
  config,
  ...
}: let
  inherit (config.modules.desktops) common;
  cfg = config.modules.desktops.hyprland;
  packageSet =
    if cfg.useGit
    then inputs.hyprland.packages
    else pkgs;
in {
  options.modules.desktops.hyprland = {
    enable = lib.mkEnableOption "Enable Hyprland and other components of the shell";
    useGit = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use latest commit on the main branch";
    };
    mainModKey = lib.mkOption {
      type = lib.types.str;
      default = "SUPER";
    };
    settings = lib.mkOption {
      type = self.lib.types.hyprType;
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    modules.services.user.hyprpaper.enable = lib.mkDefault true;

    modules.desktops.hyprland = {
      ignis.enable = lib.mkDefault true;
      dunst.enable = lib.mkDefault true;
      anyrun.enable = lib.mkDefault true;

      # actual defaults
      # this is such a mess
      settings = let
        monitors = builtins.listToAttrs (builtins.map (output: let
            mon = common.monitors.${output};
            ident =
              if mon.description != null
              then "desc:${mon.description}"
              else output;
          in {
            name = "monitorv2[${ident}]";
            value = {
              mode = "${mon.resolution}@${toString mon.refreshRate}";
              position = "${toString mon.x}x${toString mon.y}";
              cm = mon.cm.primaries;

              inherit (mon.cm) bitdepth;
              inherit (mon) scale;
            };
          })
          (builtins.attrNames common.monitors));
        base = rec {
          "$mainMod" = cfg.mainModKey;

          exec-once = [
            "dbus-update-activation-environment --systemd --all"
            "systemctl --user start hyprland-session.target"
          ];

          exec-shutdown = [
            "systemctl --user stop hyprland-session.target"
          ];

          input = {
            kb_layout = common.input.keyboardLayout;
            follow_mouse = 1;

            inherit (common.input) sensitivity;
            accel_profile = "flat";
          };

          env = [
            "XDG_CURRENT_DESKTOP,Hyprland"
            "XDG_SESSION_TYPE,wayland"
            "XDG_SESSION_DESKTOP,Hyprland"

            "GDK_BACKEND,wayland,x11,*"
            "QT_QPA_PLATFORM,wayland;xcb"
            "ELECTRON_OZONE_PLATFORM_HINT,auto"
          ];

          misc = {
            force_default_wallpaper = 0;
            disable_hyprland_logo = true;
            enable_anr_dialog = false;
            vrr = 2;
          };

          render = {
            cm_fs_passthrough = 2;
            cm_auto_hdr = 2;
            cm_sdr_eotf = 2;
          };

          general = {
            gaps_in = 8;
            gaps_out = "8, 16, 16, 16";
            border_size = 2;

            "col.active_border" = "rgba(${common.style.accentColor}ff)";
            "col.inactive_border" = "rgba(${common.style.inactiveColor}ff)";

            resize_on_border = false;
            allow_tearing = true;
            layout = "dwindle";
          };

          decoration = {
            rounding = 12;
            rounding_power = 2;
            active_opacity = 1.0;
            inactive_opacity = 1.0;

            shadow = {
              enabled = true;
              range = 10;
              render_power = 3;
            };

            blur = {
              enabled = true;
              popups = true;
              size = 2;
              passes = 3;
              noise = 0;
              contrast = 1;
              brightness = 1;
              vibrancy = 0.3;
            };
          };

          animations = {
            enabled = true;

            bezier = [
              "easeOutQuint, 0.23, 1, 0.32, 1"
              "easeInOutCubic, 0.65, 0.05, 0.36, 1"
              "linear, 0, 0, 1, 1"
              "almostLinear, 0.5, 0.5, 0.75, 1"
              "quick, 0.15, 0, 0.1, 1"
            ];

            animation = [
              "global, 1, 30, default"
              "border, 1, 3.39, easeOutQuint"
              "windows, 1, 4.79, easeOutQuint"
              "windowsIn, 1, 4.1, easeOutQuint"
              "windowsOut, 1, 1.49, linear, popin 87%"
              "fadeIn, 1, 1.73, almostLinear"
              "fadeOut, 1, 1.46, almostLinear"
              "fade, 1, 3.03, quick"
              "layers, 1, 3.81, easeOutQuint"
              "layersIn, 1, 4, easeOutQuint, fade"
              "layersOut, 1, 1.5, linear, fade"
              "fadeLayersIn, 1, 1.79, almostLinear"
              "fadeLayersOut, 1, 1.39, almostLinear"
              "workspaces, 1, 3.25, easeOutQuint, slide"
            ];
          };

          bind =
            [
              "$mainMod, C, killactive"
              "$mainMod, X, togglefloating"
              "$mainMod, F, fullscreen"
              "$mainMod, M, exit"

              "$mainMod, left, movefocus, l"
              "$mainMod, right, movefocus, r"
              "$mainMod, up, movefocus, u"
              "$mainMod, down, movefocus, d"

              "$mainMod, mouse_down, workspace, e+1"
              "$mainMod, mouse_up, workspace, e-1"
            ]
            ++ builtins.map (n: "$mainMod, ${
              if n == 10
              then "0"
              else toString n
            }, workspace, ${toString n}") (lib.range 1 10)
            ++ builtins.map (n: "$mainMod SHIFT, ${
              if n == 10
              then "0"
              else toString n
            }, movetoworkspace, ${toString n}") (lib.range 1 10);

          bindm = [
            "$mainMod, mouse:272, movewindow"
            "$mainMod, mouse:273, resizewindow"
          ];

          windowrule = [
            "suppress_event maximize, match:class .*"
            "no_focus on, match:class ^$, match:title ^$, match:xwayland 1, match:float 1, match:fullscreen 0, match:pin 0"

            "idle_inhibit none, match:class .*"
            "idle_inhibit focus, match:content 1"
            "idle_inhibit focus, match:content 2"
            "idle_inhibit focus, match:class ^(steam_app_\\d+|steam_proton|gamescope)$"

            # Use inactive border color when only 1 window is visible to be more OLED friendly
            "border_color ${general."col.inactive_border"}, match:float 0, match:workspace w[tv1]"
            "border_color ${general."col.inactive_border"}, match:float 0, match:workspace f[1]"
          ];
        };
      in
        base // monitors;
    };

    programs.hyprland = {
      enable = true;
      withUWSM = false;
      xwayland.enable = true;
      package = packageSet.hyprland;
      portalPackage = packageSet.xdg-desktop-portal-hyprland;
    };

    hj.xdg.config.files."hypr/hyprland.conf".text = self.lib.generators.toHyprconf {
      attrs = cfg.settings;
      importantPrefixes = ["$" "exec-once" "bezier"];
    };

    systemd.user.targets.hyprland-session = {
      description = "Hyprland session";
      bindsTo = ["graphical-session.target"];
      wants = ["graphical-session-pre.target"];
      after = ["graphical-session-pre.target"];
    };
  };
}
