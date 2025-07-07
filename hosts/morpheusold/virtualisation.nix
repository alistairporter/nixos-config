{ config, lib, pkgs, ... }:

{
  virtualisation = {
    vmware.guest.enable = true;
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };
}
