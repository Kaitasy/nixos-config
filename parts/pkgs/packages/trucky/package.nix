{
  stdenv,
  lib,
  appimageTools,
  curl,
  cacert,
}: let
  version = "2026-03-30";
  pname = "trucky";

  srcUrl = "https://client-download.truckyapp.com/linux/latest/Trucky.AppImage";
in
  appimageTools.wrapType2 {
    inherit pname version;

    src = stdenv.mkDerivation {
      name = "trucky-appimage";

      outputHashMode = "recursive";
      outputHash = "sha256-guaBs4aPG5NsZny+o18UuV0Hvu/mCdiU0niUjte1lH4=";

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
