{ lib, pkgs,config, ...}:

{
  imports = [
    ./audio.nix
    ./digi-amp-plus.nix
    ./pkgs-overlays.nix
  ];

  boot.kernelPackages = lib.mkDefault pkgs.linuxKernel.packages.linux_rpi3;

  # fix the following error :
  # modprobe: FATAL: Module ahci not found in directory
  # https://github.com/NixOS/nixpkgs/issues/154163#issuecomment-1350599022
  nixpkgs.overlays = [
    (_final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  # https://github.com/NixOS/nixpkgs/blob/b72bde7c4a1f9c9bf1a161f0c267186ce3c6483c/nixos/modules/installer/sd-card/sd-image-aarch64.nix#L12
  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = lib.mkDefault false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = lib.mkDefault true;

  hardware.i2c.enable = true;
  hardware.deviceTree = {
    enable = true;
    filter = lib.mkDefault "bcm2837-rpi-3-*.dtb";
  };


  assertions = [
    {
      assertion = (lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.1");
      message = "This version of raspberry pi 3 dts overlays requires a newer kernel version (>=6.1). Please upgrade nixpkgs for this system.";
    }
  ];

  # Required for wifi firmware
  hardware.enableRedistributableFirmware = true;

  # The last console argument in the list that linux can find at boot will receive kernel logs.
  # The serial ports listed here are:
  # - ttyS0: serial
  # - tty0: hdmi
  boot.kernelParams = [
    "console=ttyS0,115200n8"
    "console=tty0"
  ];

}
