{ config, lib, pkgs, ... }:

{
  imports = [
    ./netdata.nix
  ];
  # Scrutiny Collector 
  services.scrutiny.collector = {
    enable = true;
    settings = {
      log.level = "INFO";
      api.endpoint = "http://10.10.10.2:8081";
    };
  };
  
  # Prometheus Collector
  services.prometheus.exporters.node.enable = true; 

  # Beszel Agent:
  #
  services.beszel.agent = {
    enable = true;
    environmentFile = "${config.sops.secrets.beszel_key_atlantis.path}";
  };

}
