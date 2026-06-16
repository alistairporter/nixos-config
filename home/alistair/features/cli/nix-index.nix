{inputs, ...}: {
  imports = [inputs.nix-index-database.homeModules.nix-index];

  programs.nix-index.enable = true; # integrate with shell

  programs.nix-index-database.comma.enable = true; # enable comma with wrapper to use nix-index-database
}
