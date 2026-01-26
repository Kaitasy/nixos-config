{pkgs, ...}:
pkgs.gpu-screen-recorder.overrideAttrs (old: {
  patches = (old.patches or []) ++ [./obs-vkcapture-patch01.patch];
})
