{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.hardware.nixosModules.common-gpu-intel-kaby-lake
    inputs.hardware.nixosModules.lenovo-thinkpad-t480

    ./hardware-configuration.nix

    ../common/global
    ../common/users/alistair

    ../common/optional/quietboot.nix
    ../common/optional/secure-boot.nix
    ../common/optional/gnome.nix
    ../common/optional/flatpak.nix
    ../common/optional/pipewire.nix
    ../common/optional/gnome-boxes.nix
  ];

  networking = {
    hostName = "midgard";
    networkmanager.enable = true;
  };

  services.resolved = {
    enable = true;
  };

  # Override mount options in 'hardware-configuration.nix'
  fileSystems = {
    "/".options = ["compress=zstd"];
    "/home".options = ["compress=zstd"];
    "/nix".options = ["compress=zstd" "noatime"];
    #    "/swap".options = [ "noatime" ];
  };

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
    binfmt.emulatedSystems = [
      "aarch64-linux"
      "i686-linux"
    ];
  };

  powerManagement.powertop.enable = true;
  programs = {
    # light.enable = true;
    # adb.enable = true;
    # dconf.enable = true;
  };
  environment.systemPackages = [];

  # # Lid settings
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "lock";
    powerKey = "suspend";
    powerKeyLongPress = "poweroff";
  };

  hardware.graphics.enable = true;

  system.stateVersion = "25.05";
}
