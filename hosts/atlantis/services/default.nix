{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./avahi.nix
    ./samba.nix
  ];
}
