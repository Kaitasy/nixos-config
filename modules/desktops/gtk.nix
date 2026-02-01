{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (config.modules.core) fonts;
  inherit (config.modules.desktops.common) cursor;
in {
  config = {
    hj = {
      packages = with pkgs; [
        adw-gtk3
        adwaita-icon-theme
      ];

      xdg.config.files."gtk-4.0/gtk.css".text = "window { border-radius: 0; }";
      xdg.config.files."gtk-3.0/gtk.css".text = "window { border-radius: 0; }";
    };

    programs.dconf.profiles.user.databases = [
      {
        lockAll = true;
        settings = {
          "org/gnome/desktop/interface" = rec {
            gtk-theme = "adw-gtk3-dark";
            icon-theme = "Adwaita-Dark";
            cursor-theme = cursor.name;
            cursor-size = lib.gvariant.mkInt32 cursor.size;
            font-name = "${fonts.sans-serif.name} Regular ${toString fonts.sans-serif.preferredSize}";
            document-font-name = font-name;
            monospace-font-name = "${fonts.monospace.name} Regular ${toString fonts.monospace.preferredSize}";
            color-scheme = "prefer-dark";
            gtk-enable-primary-paste = false;
          };
          "org/gnome/desktop/wm/preferences" = {
            button-layout = "";
          };
        };
      }
    ];
  };
}
