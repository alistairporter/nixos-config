{ pkgs, misc, ... }: {

  home.packages = [
    pkgs.nerd-fonts.fira-code
    pkgs.inter
  ];
  
  fonts.fontconfig.enable = true; 

  gtk = {
    font = {
      package =  pkgs.inter;
      name = "Inter Variable";
      size = 11;
    };
  };
}
