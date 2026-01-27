{pkgs, ...}:
pkgs.obs-vkcapture.overrideAttrs (old: {
  patches = (old.patches or []) ++ [./obs-vkcapture.patch];
})
