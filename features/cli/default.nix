{ pkgs, misc, inputs, ... }: {
  imports = [
    ./zsh.nix
    ./bash.nix
    ./aliases.nix
    ./starship.nix
    ./atuin.nix
    ./thefuck.nix
    ./nix-your-shell.nix
    ./utilities.nix
    ./ssh.nix
    ./git.nix    
  ];
}
