{pkgs, ...}:
pkgs.obs-studio-plugins.obs-vkcapture.overrideAttrs (old: {
  patches = (old.patches or []) ++ [./obs-vkcapture.patch];
})
