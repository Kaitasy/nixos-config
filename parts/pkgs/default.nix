{
  inputs,
  lib,
  ...
}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    _module.args = {
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };

    packages = lib.fix (self:
      lib.packagesFromDirectoryRecursive {
        callPackage = pkgs.lib.callPackageWith (pkgs // self);
        directory = ./packages;
      });
  };
}
