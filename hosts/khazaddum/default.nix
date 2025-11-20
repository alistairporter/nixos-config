{
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.jovian.nixosModules.jovian

    ./hardware-configuration.nix

    ../common/global
    ../common/users/alistair

    ../common/optional/quietboot.nix
    ../common/optional/systemd-boot.nix
    ../common/optional/gnome.nix
    # ../common/optional/gpustuff.nix
    ../common/optional/flatpak.nix
    ../common/optional/pipewire.nix
    # ../common/optional/gnome-boxes.nix
    ../common/optional/avahi.nix
    ../common/optional/printing.nix
    ../common/optional/steam.nix
  ];

  networking = {
    hostName = "khazaddum";
    networkmanager.enable = true;
  };

  services.resolved = {
    enable = true;
  };

  # enable the jovian steamdeck hardware stuff
  jovian.devices.steamdeck.enable = true;

  # enable jovian steam deck ui tooling
  jovian.steam.enable = true;
  jovian.steam.autoStart = true;
  jovian.steam.user = "alistair";
  jovian.steam.desktopSession = "gnome";
  services.displayManager.gdm.enable = lib.mkForce false;
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

  # powerManagement.powertop.enable = true;
  programs = {
    # light.enable = true;
    # adb.enable = true;
    # dconf.enable = true;
  };
  environment.systemPackages = with pkgs; [
    steamdeck-firmware
    jupiter-dock-updater-bin
  ];

  hardware.graphics.enable = true;

  system.stateVersion = "25.05";
}
