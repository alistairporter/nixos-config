{ pkgs, misc, ... }: {
  # FEEL FREE TO EDIT: This file is NOT managed by fleek. 
  programs.zsh.initExtraBeforeCompInit = ''
    fpath+=("/usr/share/zsh/site-functions /usr/share/zsh/$ZSH_VERSION/functions /usr/share/zsh/vendor-completions)
  '';
 
}
