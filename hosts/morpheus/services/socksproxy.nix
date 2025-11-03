{
  config,
  lib,
  pkgs,
  ...
}: {
  services = {
    microsocks = {
      enable = true;
      ip = "10.10.10.1";
      port = 1080;
      authUsername = "proxy";
      authPasswordFile = "/run/secrets/microsocks_password_morpheus";
    };
  };

  sops.secrets.microsocks_password_morpheus = {
    owner = "microsocks";
    group = "microsocks";
    mode = "0440";
    sopsFile = ../secrets.yaml;
  };

  networking.firewall.allowedTCPPorts = [config.services.microsocks.port];
}
