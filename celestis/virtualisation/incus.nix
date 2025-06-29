
{ config, lib, pkgs, ... }:

{
  virtualisation.incus = {
    enable = true;
    ui.enable = true;
  };
}
