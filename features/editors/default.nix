{ pkgs, misc, ... }: {
  imports = [
    ./nano.nix
    ./helix.nix
    ./neovim.nix
    ./micro.nix
  ]
}
