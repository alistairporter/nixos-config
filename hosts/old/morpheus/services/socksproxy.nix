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
}
