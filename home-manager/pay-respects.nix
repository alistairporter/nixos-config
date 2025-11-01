{ pkgs, misc, ... }: {
#
# pay-respects for awesome comand correction
#
  programs.pay-respects = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };
}
