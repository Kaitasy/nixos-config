{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.desktops.hyprland.anyrun;
in {
  options.modules.desktops.hyprland.anyrun = {
    enable = lib.mkEnableOption "anyrun";
    plugins = {
      enableRink = lib.mkEnableOption "Calculator & unit conversion plugin";
      enableNixRun = lib.mkEnableOption "Nix run plugin";
    };
  };

  config = lib.mkIf cfg.enable {
    modules.desktops.hyprland.settings = {
      layerrule = [
        "blur on, match:namespace anyrun"
        "ignore_alpha 0.6, match:namespace anyrun"
      ];
      bind = [
        "$mainMod, R, exec, ${pkgs.anyrun} -c ~/.config/anyrun/hypr"
      ];
    };

    hj = {
      packages = [pkgs.anyrun];

      xdg.config.files."anyrun/hypr/config.ron".text = let
        plugins =
          ["${pkgs.anyrun}/lib/libapplications.so"]
          ++ lib.optionals cfg.plugins.enableRink ["${pkgs.anyrun}/lib/librink.so"]
          ++ lib.optionals cfg.plugins.enableNixRun ["${pkgs.anyrun}/lib/libnix_run.so"];
      in ''
        Config(
          x: Fraction(0.5),
          y: Fraction(0.5),
          width: Absolute(800),
          height: Absolute(0),
          layer: Overlay,
          keyboard_mode: Exclusive,
          max_entries: 8,
          close_on_click: true,
          plugins: ${builtins.toJSON plugins}
        )
      '';

      # TODO: Theme anyrun
      # TODO: Enable anyrun daemon for faster startups
    };
  };
}
