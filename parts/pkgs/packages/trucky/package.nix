{
  stdenv,
  lib,
  appimageTools,
  curl,
  cacert,
}: let
  version = "2026-02-09";
  pname = "trucky";

  srcUrl = "https://client-download.truckyapp.com/linux/latest/Trucky.AppImage";
in
  appimageTools.wrapType2 {
    inherit pname version;

    src = stdenv.mkDerivation {
      name = "trucky-appimage";

      outputHashMode = "recursive";
      outputHash = "sha256-Ew6obvhLbPwcTU90wdWs0wxa7mS2U7U55vHtbT3sDJQ=";

      nativeBuildInputs = [curl cacert];
      buildPhase = ''
        export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt

        curl \
          -L \
          -A "Mozilla/5.0 (X11; Linux x86_64; rv:146.0) Gecko/20100101 Firefox/146.0" \
          ${srcUrl} \
          -o "$out"
      '';

      unpackPhase = "true";
      installPhase = "true";
    };

    extraInstallCommands = ''
      mkdir -p $out/share/applications
      install -Dm444 ${./trucky.desktop} $out/share/applications/trucky.desktop
    '';

    meta = {
      mainProgram = "trucky";
      homepage = "https://truckyapp.com";
      platforms = ["x86_64-linux"];
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
    };
  }
