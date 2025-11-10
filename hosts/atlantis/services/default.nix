{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./avahi.nix
    ./garage.nix
    ./samba.nix
  ];
}
