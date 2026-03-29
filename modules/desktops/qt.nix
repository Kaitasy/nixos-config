{
  pkgs,
  inputs,
  config,
  ...
}: let
  inherit (config.modules.core) fonts;
in {
  imports = [
    inputs.qtengine.nixosModules.default
  ];

  config = {
    programs.qtengine = {
      enable = true;
      config = {
        theme = {
          colorScheme = "${pkgs.kdePackages.breeze}/share/color-schemes/BreezeDark.colors";
          iconTheme = "breeze-dark";
          style = "breeze";

          font = {
            family = fonts.sans-serif.name;
            size = fonts.sans-serif.preferredSize;
          };

          fontFixed = {
            family = fonts.monospace.name;
            size = fonts.monospace.preferredSize;
          };
        };
      };
    };

    hj = {
      packages = with pkgs.kdePackages; [
        breeze
        breeze.qt5
        breeze-icons
      ];
    };
  };
}
