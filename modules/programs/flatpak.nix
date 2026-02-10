{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.programs.flatpak;
in {
  options.modules.programs.flatpak = {
    enable = lib.mkEnableOption "Flatpak";
    gaming = {
      sober = lib.mkEnableOption "Roblox on Linux";
      hytale = lib.mkEnableOption "Hytale";
    };
    creativity = {
      kdenlive = lib.mkEnableOption "Kdenlive";
    };
    utility = {
      bottles = lib.mkEnableOption "Bottles";
      gradia = lib.mkEnableOption "Screenshot annotation tool";
    };
  };

  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  config = lib.mkIf cfg.enable {
    services.flatpak = {
      enable = true;

      packages =
        lib.optionals cfg.gaming.sober [
          {
            appId = "org.vinegarhq.Sober";
            origin = "flathub";
          }
        ]
        ++ lib.optionals cfg.gaming.hytale [
          rec {
            appId = "com.hytale.HytaleLauncher";
            bundle = "${pkgs.fetchurl {
              url = "https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-latest.flatpak";
              inherit sha256;
            }}";
            sha256 = "0mx2pnjgy9r7i8g3ww10fj64c8isl721qnvpyf4yiviiy23h2v0q";
          }
        ]
        ++ lib.optionals cfg.creativity.kdenlive [
          {
            appId = "org.kde.kdenlive";
            origin = "flathub";
          }
        ]
        ++ lib.optionals cfg.utility.bottles [
          {
            appId = "com.usebottles.bottles";
            origin = "flathub";
          }
        ]
        ++ lib.optionals cfg.utility.gradia [
          {
            appId = "be.alexandervanhee.gradia";
            origin = "flathub";
          }
        ];

      overrides = {
        # Who needs sandboxing anyway
        "com.usebottles.bottles".Context = {
          filesystems = ["host"];
          devices = ["all"];
        };
      };
    };
  };
}
