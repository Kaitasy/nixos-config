{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) types mkOption;
  cfg = config.modules.programs.web.librewolf;

  mkExtension = guid: shortId: {
    name = guid;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
      installation_mode = "force_installed";
    };
  };
in {
  options.modules.programs.web.librewolf = {
    enable = lib.mkEnableOption "Librewolf";
    defaultSearchEngine = mkOption {
      type = types.str;
      default = "startpage";
    };
    extraSearchEngines = mkOption {
      type = types.listOf (types.submodule {
        options = {
          Name = mkOption {
            type = types.str;
            example = "SearXNG";
          };
          URLTemplate = mkOption {
            type = types.str;
            example = "https://some-searxng-instance.com/search?q=%s";
          };
        };
        default = {};
      });
      default = [];
    };
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.librewolf;
      policies = {
        extraPolicies = {
          DisableTelemtry = true;
          ExtensionSettings = builtins.listToAttrs [
            (mkExtension "ublock-origin" "uBlock0@raymondhill.net")
            (mkExtension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
            (mkExtension "sponsorblock" "sponsorBlocker@ajay.app")
          ];

          SearchEngines = {
            Default = cfg.defaultSearchEngine;
            Add = cfg.extraSearchEngines;
          };
        };
      };
    };
  };
}
