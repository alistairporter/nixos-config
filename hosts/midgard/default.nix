{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-pc-ssd
    /*
      This is referenced "indirectly" through its path, rather
      than through `inputs.nixos-hardware.nixosModules` because of
      <https://github.com/NixOS/nixos-hardware/issues/992>.
    */
    # TODO: Fix this when <https://github.com/NixOS/nixos-hardware/issues/992> gets merged.
    "${inputs.hardware}/common/gpu/intel/kaby-lake"
    inputs.hardware.nixosModules.lenovo-thinkpad-t480

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
    ../common/optional/steam.nix
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

  # Power Button & Lid settings
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend"; # suspend on lid close
    HandleLidSwitchExternalPower = "lock"; # lock on lid close when power connected
    HandlePowerKey = "suspend"; # suspend on power button
    HandlePowerKeyLongPress = "poweroff"; # power off on power button hold
  };

  hardware.graphics.enable = true;

  system.stateVersion = "25.05";
}
