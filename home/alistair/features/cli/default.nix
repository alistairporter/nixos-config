{ pkgs, misc, inputs, ... }: {
  imports = [
    ./aliases.nix
    ./atuin.nix
    ./bash.nix
    ./bat.nix
    ./dircolors.nix
    ./direnv.nix
    ./eza.nix
    ./git.nix
    ./nano.nix
    ./nix-index.nix
    ./nix-your-shell.nix
    ./pay-respects.nix
    ./ssh.nix
    ./starship.nix
    ./tmux.nix
    ./zsh.nix
  ];
  home.packages = with pkgs; [
    comma # Install and run programs by sticking a , before them
    distrobox # Nice escape hatch, integrates docker images with my environment

    bc # Calculator
    bottom # System viewer
    ncdu # TUI disk usage
    ripgrep # Better grep
    fd # Better find
    httpie # Better curl
    jq # JSON pretty printer and manipulator
    htop # better top
    btop # even better top
    fastfetch # better neofetch
    sl # encourage better typing
    sops # secret managment
    lolcat # for the lols
    cheat # no fecking clue what this does tbh
    glow # markdown renderer
    nixd # Nix LSP
    alejandra # Nix formatter
    nixfmt-rfc-style
    nvd # Differ
    nix-diff # Differ, more detailed
    nix-output-monitor
    nh # Nice wrapper for NixOS and HM
    uv # python package manager
  ];
}
