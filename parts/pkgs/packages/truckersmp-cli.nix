{
  python3Packages,
  pkgsCross,
  gnumake,
  SDL2,
}: let
  pname = "truckersmp-cli";
  version = "0.10.2.1";
  src = builtins.fetchGit {
    url = "https://github.com/truckersmp-cli/truckersmp-cli";
    ref = "main";
    rev = "b9c50d07819772f1a561965775224836669f8e2c";
  };

  injector = pkgsCross.mingwW64.stdenv.mkDerivation {
    inherit version src;
    pname = "truckersmp-cli-injector";

    dontConfigure = true;

    nativeBuildInputs = [
      gnumake
    ];

    makeFlags = [
      "CC=${pkgsCross.mingwW64.stdenv.cc.targetPrefix}gcc"
    ];

    buildPhase = ''
      make truckersmp_cli/truckersmp-cli.exe
    '';

    installPhase = ''
      ls -la
      mkdir -p $out
      cp truckersmp_cli/truckersmp-cli.exe $out/
    '';
  };
in
  python3Packages.buildPythonApplication {
    inherit pname version src;
    format = "setuptools";

    buildInputs = [
      SDL2
      python3Packages.vdf
    ];

    preBuild = ''
      cp ${injector}/truckersmp-cli.exe ./truckersmp_cli/truckersmp-cli.exe
    '';
  }
