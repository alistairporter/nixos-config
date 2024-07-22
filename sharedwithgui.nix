{ pkgs, misc, ... }: {
  gtk = {
    enable = true;
    font = {
      package =  pkgs.inter;
      name = "Inter Variable";
      size = 11;
    };
#    cursorTheme = {
#      name = "Vimix-Cursors";
#      package = pkgs.vimix-cursor-theme;
#      size = 24;
#    }; 
  };
}
