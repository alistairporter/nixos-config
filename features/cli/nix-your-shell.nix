{ pkgs, misc, ... }: {
  programs.nix-your-shell = {
    enable = true;
    enableZshIntegration = true;
  };
}
