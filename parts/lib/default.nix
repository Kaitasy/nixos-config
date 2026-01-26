{lib, ...}: {
  flake.lib = {
    generators = import ./generators lib;
    types = import ./types lib;
    services = import ./services.nix;
  };
}
