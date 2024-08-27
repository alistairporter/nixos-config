{ config, pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./monitoring.nix
    ./networking.nix
    ./packages.nix
    ./services/services.nix
    ./usersandgroups.nix
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  time.timeZone = "Europe/London";

  system = {
    stateVersion = "23.11";
    autoUpgrade = {
      enable = true;
      allowReboot = true;
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes"];
}  
