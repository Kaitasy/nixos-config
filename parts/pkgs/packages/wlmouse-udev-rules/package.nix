{
  stdenv,
  udevCheckHook,
}:
stdenv.mkDerivation {
  pname = "wlmouse-udev-rules";
  version = "2025-12-26";

  src = [./wlmouse.rules];
  nativeBuildInputs = [udevCheckHook];
  doInstallCheck = true;
  dontUnpack = true;
  installPhase = ''
    install -Dpm644 $src $out/lib/udev/rules.d/70-wlmouse.rules
  '';
}
