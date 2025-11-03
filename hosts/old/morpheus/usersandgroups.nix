{
  config,
  lib,
  pkgs,
  ...
}: {
  users.users.alistair = {
    extraGroups = ["wheel" "networkmanager" "docker"];
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.zsh;
    hashedPassword = "SECRET_REDACTED";
  };
  users.users.netdata = {
    extraGroups = ["docker"];
  };
}
