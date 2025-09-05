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
  systemd.services.beszel = {
    enable = true;
    description = "Beszel Agent Service";
    environment = {
      PORT = "45876";
    };
    after = ["network.target"];
    serviceConfig = {
      ExecStart = "${pkgs.beszel}/bin/beszel-agent";
      EnvironmentFile = "${config.sops.secrets.beszel_key_morpheus.path}";
    };

    wantedBy = [ "multi-user.target" ];
  };
}
