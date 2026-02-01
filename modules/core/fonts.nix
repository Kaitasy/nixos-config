{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.core.fonts;
  mkFontOptions = name: package: {
    name = lib.mkOption {
      type = lib.types.str;
      default = name;
    };
    package = lib.mkOption {
      type = lib.types.package;
      default = package;
    };
    preferredSize = lib.mkOption {
      type = lib.types.int;
      default = 11;
    };
  };
in {
  options.modules.core.fonts = {
    serif = mkFontOptions "Noto Serif" pkgs.noto-fonts;
    sans-serif = mkFontOptions "Noto Sans" pkgs.noto-fonts;
    monospace = mkFontOptions "JetBrainsMono Nerd Font" pkgs.nerd-fonts.jetbrains-mono;
    emoji = mkFontOptions "Noto Color Emoji" pkgs.noto-fonts-color-emoji;
  };

  config = {
    fonts = {
      enableDefaultPackages = false;
      packages = [
        cfg.serif.package
        cfg.sans-serif.package
        cfg.monospace.package
        cfg.emoji.package
        pkgs.noto-fonts-cjk-sans
      ];

      fontconfig = {
        enable = true;

        subpixel.rgba = lib.mkDefault "rgb";
        hinting.style = "slight";
        antialias = true;
        useEmbeddedBitmaps = true;

        defaultFonts = {
          serif = [cfg.serif.name];
          sansSerif = [cfg.sans-serif.name];
          monospace = [cfg.monospace.name];
          emoji = [cfg.emoji.name];
        };
      };
    };
  };
}
