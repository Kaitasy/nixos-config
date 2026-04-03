{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:
buildGoModule (finalAttrs: {
  pname = "surge";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "SurgeDM";
    repo = "surge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DGBZi5cK7wenCV9M1MyQM1bhFNXNaK44BPyw/cZ6+Tc=";
  };

  vendorHash = "sha256-dM0MpXdvxn7RH4USOyeIOVsdoyE4VUw+U44Qc9IkK5s=";

  checkPhase = "true";

  meta = {
    description = "Blazing fast TUI download manager built in Go for power users";
    homepage = "https://github.com/SurgeDM/Surge";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "Surge";
  };
})
