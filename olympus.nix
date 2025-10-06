{ pkgs, misc, ... }: {

  home.username = "alistair";
  home.homeDirectory = "/home/alistair";
    
  programs.zsh.initExtraBeforeCompInit = ''
    fpath+=(/usr/share/zsh/site-functions /usr/share/zsh/$ZSH_VERSION/functions /usr/share/zsh/vendor-completions)
  '';
  
}
