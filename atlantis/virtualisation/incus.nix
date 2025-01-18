
{ config, lib, pkgs, ... }:

{
  virtualisation.incus = {
    enable = true;
  };
}
