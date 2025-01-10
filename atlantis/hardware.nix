{ config, lib, pkgs, ... }:

{
  # Hardware:
  ## nvidia stuff
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia-container-toolkit.enable = true;
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  ## apcupsd for ups
  services.apcupsd = {
    enable = true;
    configText = ''
      UPSCABLE usb
      UPSTYPE usb
      NISIP 0.0.0.0
      MINUTES 10
    '';
  };
}
