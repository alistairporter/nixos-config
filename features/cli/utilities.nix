{ pkgs, misc, inputs, ... }: {
#
# Shell essential programs:
#
  # better cat
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [ batdiff batman batgrep batwatch batpipe];
  };

  # better ls
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
  };

  # dircolours
  programs.dircolors.enable = true;

  # shell multiplexer
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    terminal = "screen-256color";
    extraConfig = ''
      bind-key @ choose-window 'join-pane -h -s "%%"'
      bind  c  new-window      -c "#{pane_current_path}"
      bind  %  split-window -h -c "#{pane_current_path}"
      bind '"' split-window -v -c "#{pane_current_path}"
    '';
  };
  
  programs.nix-index-database.comma.enable = true;
  programs.nix-index.enable = true;

  home.packages = with pkgs; [
#    comma # Install and run programs by sticking a , before them
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
  ];
}
