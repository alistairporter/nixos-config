{
  config,
  lib,
  pkgs,
  ...
}: {
  services = {
    microsocks = {
      enable = true;
      ip = "0.0.0.0";
      port = 1080;
      authUsername = "proxy";
      authPasswordFile = "/run/secrets/microsocks_password_morpheus";
    };
  };

  sops.secrets.microsocks_password_morpheus = {
    sopsFile = ../secrets.yaml;
  };

  networking.firewall.allowedTCPPorts = [config.services.microsocks.port];
}
