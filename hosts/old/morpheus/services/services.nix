{ config, lib, pkgs, ...}:

{
  imports = [
    ./ssh.nix
    ./reverseproxy.nix
    ./socksproxy.nix
    ./tailscale.nix
  ];
}
