{ config, lib, pkgs, ...}:

{
  imports = [
    ./tailscale.nix
    ./avahi.nix
  ];
}
