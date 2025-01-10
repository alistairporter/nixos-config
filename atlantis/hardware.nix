{ config, lib, pkgs, ... }:

{
  # Hardware:
  ## nvidia stuff
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia.open = true;
  hardware.nvidia-container-toolkit.enable = true;
  hardware.graphics.enable = true;
  
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
