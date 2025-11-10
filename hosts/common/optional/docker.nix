{
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    package = pkgs.docker_27; # as of 2024, required to have cdi support working.
    autoPrune.enable = true;
    daemon.settings = {
      # metrics for collection by prometheus.
      metrics-addr = "0.0.0.0:9323";

      # store logs in a sane format and limit the size to not have a repeat of the 120GB log file incident.
      log-driver = "json-file";
      log-opts = {
        max-file = "3";
        max-size = "10m";
      };

      # enable cdi for nvidia-container-driver, required for nvidia gpu's to work inside containers.
      features = {
        cdi = true;
      };
    };
  };

  # allow docker metrics through firewall on tailnet.
  networking.firewall.interfaces."tailscale0" = {
    allowedTCPPorts = [
      9323
    ];
  };
}
