{
  pkgs,
  self,
  lib,
  config,
  ...
}: let
  inherit (lib) types mkOption;

  cfg = config.modules.services.user.easyeffects;
in {
  options.modules.services.user.easyeffects = {
    enable = lib.mkEnableOption "EasyEffects";
    presets = {
      input = mkOption {
        type = types.attrs;
        default = {};
      };
      output = mkOption {
        type = types.attrs;
        default = {};
      };
    };
    autoload = rec {
      output = mkOption {
        type = types.listOf (types.submodule {
          options = {
            device = mkOption {
              type = types.str;
            };
            device-description = mkOption {
              type = types.str;
            };
            device-profile = mkOption {
              type = types.str;
            };
            preset-name = mkOption {
              type = types.str;
            };
          };
        });
        default = [];
      };
      input = output;
    };
  };

  config = lib.mkIf cfg.enable {
    hj = {
      packages = [pkgs.easyeffects];

      systemd.services.easyeffects = self.lib.services.mkGraphicalSessionService {
        description = "EasyEffects";
        path = [];
        execStart = "${lib.getExe pkgs.easyeffects} --service-mode --hide-window";
      };

      # autoload
      xdg.data.files = let
        mkPreset = type: name: preset: {
          name = "easyeffects/${type}/${name}.json";
          value = {
            generator = lib.generators.toJSON {};
            value.${type} = preset;
          };
        };
        mkPresetList = type:
          map (name: mkPreset type name cfg.presets.${type}.${name}) (builtins.attrNames cfg.presets.${type});

        mkAutoload = type: autoload: {
          name = "easyeffects/autoload/${type}/${autoload.device}.json";
          value = {
            generator = lib.generators.toJSON {};
            value = autoload;
          };
        };

        inputPresets = mkPresetList "input";
        outputPresets = mkPresetList "output";
        inputAutoload = map (autoload: mkAutoload "input" autoload) cfg.autoload.input;
        outputAutoload = map (autoload: mkAutoload "output" autoload) cfg.autoload.output;
      in
        builtins.listToAttrs (inputPresets ++ outputPresets ++ inputAutoload ++ outputAutoload);
    };
  };
}
