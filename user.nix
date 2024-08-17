{ pkgs, misc, ... }: {

#  home.file = {
#    ".nanorc" = {
#      enable = true;
#      target = "./";
#      text = ''
#        set atblanks
#        set autoindent
#        set constantshow
#        set cutfromcursor
#        set indicator
#        set linenumbers
#        set minibar
#        set showcursor
#        set softwrap
#        set speller "aspell -x -c"
#        set trimblanks
#        set whitespace "»·"
#        set zap
#        set multibuffer
#      '';
#    };
#  };
  
  xdg = {
    enable = true;
  }; 
}
