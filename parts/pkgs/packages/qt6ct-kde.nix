# qt6ct-kde by ilya-fedin on the AUR
# Also add Breeze as an input because of nixos shenanigans
{pkgs, ...}:
pkgs.qt6Packages.qt6ct.overrideAttrs (old: {
  buildInputs = (old.buildInputs or []) ++ [pkgs.kdePackages.breeze];
  patches =
    (old.patches or [])
    ++ [
      (builtins.fetchurl
        {
          url = "https://aur.archlinux.org/cgit/aur.git/plain/qt6ct-shenanigans.patch?h=qt6ct-kde";
          sha256 = "1igxin99ia0a5c8j00d43gpvgkwygv2iphjxhw1bx52aqm3054sm";
        })
    ];
})
