{ pkgs, misc, ... }: {
#
# thefuck for awesome comand correction
#
  programs.thefuck = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };
}
