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
  systemd.services.beszel = {
    enable = true;
    description = "Beszel Agent Service";
    environment = {
      PORT = "45876";
    };
    path = [ pkgs.linuxPackages.nvidia_x11 ];
    after = ["network.target"];
    serviceConfig = {
      ExecStart = "${pkgs.beszel}/bin/beszel-agent";
      EnvironmentFile = "${config.sops.secrets.beszel_key_atlantis.path}";
    };

    wantedBy = [ "multi-user.target" ];
  };
}
