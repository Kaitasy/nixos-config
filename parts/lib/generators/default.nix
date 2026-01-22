lib: {
  inherit (import ./hyprlang.nix lib) toHyprlang;
  inherit (import ./hyprconf.nix lib) toHyprconf;
}
