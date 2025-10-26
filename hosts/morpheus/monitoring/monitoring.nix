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

  # Beszel Agent:
  #
  services.beszel.agent = {
    enable = true;
    environmentFile = "${config.sops.secrets.beszel_key_morpheus.path}";
  };
}
