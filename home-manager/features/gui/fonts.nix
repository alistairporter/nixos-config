{ pkgs, misc, ... }: {

  home.packages = [
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.fira-mono
    pkgs.fira
    pkgs.inter
    pkgs.corefonts
    pkgs.vistafonts
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
