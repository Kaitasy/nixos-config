{lib, ...}: let
  inherit (lib) filesystem hasSuffix hasPrefix;
  files = filesystem.listFilesRecursive ./.;
  filterFiles = path: path != ./default.nix && hasSuffix ".nix" (baseNameOf path) && !hasPrefix "_" (baseNameOf path);
in {
  flake.nixosModules.default = {
    imports = builtins.filter filterFiles files;
  };
}
