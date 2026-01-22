{
  self,
  inputs,
  lib,
  withSystem,
  ...
}: let
  hosts = {snowflake = "x86_64-linux";};

  mkSystem = hostname: system:
    withSystem system ({
      inputs',
      self',
      ...
    }:
      lib.nixosSystem {
        specialArgs = {
          inherit self self' inputs inputs';
        };
        modules = [
          # idk if this is needed but just in case
          {
            nixpkgs.hostPlatform = system;
          }
          self.nixosModules.default
          ./${hostname}
        ];
      });
in {
  flake.nixosConfigurations = builtins.listToAttrs (builtins.map (hostname: {
      name = hostname;
      value = mkSystem hostname hosts.${hostname};
    })
    (builtins.attrNames hosts));
}
