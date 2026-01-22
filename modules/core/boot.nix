{
  boot = {
    consoleLogLevel = 7;
    loader = {
      efi.canTouchEfiVariables = true;

      grub = {
        enable = true;
        devices = ["nodev"];
        efiSupport = true;
      };
    };
  };
}
