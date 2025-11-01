{ pkgs, misc, ... }: {
  programs.nix-your-shell = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh.initExtra = ''
    any-nix-shell zsh --info-right | source /dev/stdin
  '';
  
  home.packages = [  pkgs.any-nix-shell ];
}
