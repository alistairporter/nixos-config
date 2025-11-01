#
# Any shared configuration for a system with a GUI.
# i.e apps and system configuration
{ pkgs, misc, inputs, ... }: {

  programs.alacritty = {
    enable = true;
  };

  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

  home.packages = with pkgs; [
    nerd-fonts.fira-code # terminal fonts
    nerd-fonts.fira-mono # more terminal fonts
    fira # yet more terminal fonts
    inter # ui font
    corefonts # windows fonts
    vistafonts # more windows fonts
  ] ++ [
    inputs.zen-browser.packages.${pkgs.system}.default # firefoxn't
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
