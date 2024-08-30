{ config, lib, pkgs, ... }:

{
  imports = [
    ./netdata.nix
  ];
  services = {
    prometheus.exporters.node = {
      enable = true;
    };
  };
}
