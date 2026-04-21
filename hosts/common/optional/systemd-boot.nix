{
  boot.loader = {
    systemd-boot = {
      enable = true;
      consoleMode = "max";
      netbootxyz.enable = true;
      edk2-uefi-shell.enable = true;
      memtest86.enable = true;
    };
    efi.canTouchEfiVariables = true;
  };
}
