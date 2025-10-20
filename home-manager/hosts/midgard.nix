{ pkgs, misc, ... }: {

  home.username = "alistair";
  home.homeDirectory = "/home/alistair";

  programs.zsh.initExtraBeforeCompInit = ''
    fpath+=(/usr/share/zsh/site-functions /usr/share/zsh/$ZSH_VERSION/functions /usr/share/zsh/vendor-completions)
  '';

  programs.zsh.initExtra = ''
    any-nix-shell zsh --info-right | source /dev/stdin
  '';
  
  home.packages = [ pkgs.sops pkgs.any-nix-shell ];
  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };
}
