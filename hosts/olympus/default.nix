{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-cpu-amd-pstate
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.hardware.nixosModules.gigabyte-b550

    ./hardware-configuration.nix

    ../common/global
    ../common/users/alistair

    ../common/optional/quietboot.nix
    ../common/optional/secure-boot.nix
    ../common/optional/gnome.nix
    ../common/optional/gpustuff.nix
    ../common/optional/flatpak.nix
    ../common/optional/pipewire.nix
    ../common/optional/gnome-boxes.nix
    ../common/optional/avahi.nix
    ../common/optional/printing.nix
  ];

  # Overrride mount options in 'hardware-configuration.nix'
  fileSystems = {
    "/".options = ["compress=zstd"];
    "/home".options = ["compress=zstd"];
    "/nix".options = ["compress=zstd" "noatime"];
    #    "/swap".options = [ "noatime" ];
  };

  networking = {
    hostName = "olympus";
    useDHCP = true;
    networkmanager.enable = true;
  };

  services.resolved.enable = true;

  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod;
    binfmt.emulatedSystems = [
      "aarch64-linux"
      "i686-linux"
    ];
  };

  powerManagement.powertop.enable = true;

  programs = {
    dconf.enable = true;
  };

  services.logind = {
    powerKey = "suspend";
    powerKeyLongPress = "poweroff";
  };

  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true; # suspend is _very_ broken if this is not enabled for some godforsaken reason.
    open = true; # use open kernel module
  };

  system.stateVersion = "25.05";
}
