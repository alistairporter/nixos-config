{ pkgs, misc, inputs, ... }: {
  imports = [
    ./zsh.nix
    ./bash.nix
    ./aliases.nix
    ./starship.nix
    ./atuin.nix
    ./utilities.nix
    ./ssh.nix
    ./git.nix    
  ];
}
