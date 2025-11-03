{pkgs, ...}: {
  fontProfiles = {
    enable = true;
    monospace = {
      name = "FiraMono Nerd Font";
      package = pkgs.nerd-fonts.fira-mono;
    };
    regular = {
      name = "Inter Variable";
      package = pkgs.inter;
    };
  };

  home.packages = with pkgs; [
    nerd-fonts.fira-code # terminal fonts
    nerd-fonts.fira-mono # more terminal fonts
    fira # yet more terminal fonts
    inter # ui font
    corefonts # windows fonts
    vista-fonts # more windows fonts
  ];

  fonts.fontconfig.enable = true;
}
