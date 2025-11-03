{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./netdata.nix
  ];
  # Scrutiny Collector
  services.scrutiny.collector = {
    enable = true;
    settings = {
      log.level = "INFO";
      api.endpoint = "http://atlantis:8081";
    };
  };

  # Prometheus Exporter
  services.prometheus.exporters.node.enable = true;

  # Beszel Agent:
  #
  services.beszel.agent = {
    enable = true;
    environment = {
      "EXTRA_FILESYSTEMS" = "/media/MiscFiles,/media/Files";
    };
    environmentFile = "${config.sops.secrets.beszel_key_atlantis.path}";
  };
}
