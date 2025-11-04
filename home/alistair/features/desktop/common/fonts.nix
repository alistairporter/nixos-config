{pkgs, lib, config, ...}: {
  fontProfiles = {
    enable = true;
    monospace = {
      name = "Fira Code";
      package = pkgs.fira-code;
      size = 10;
    };
    regular = {
      name = "Inter Variable";
      package = pkgs.inter;
      size = 11;
    };
  };

  home.packages = with pkgs; [
    # nerd-fonts.fira-code # terminal fonts
    # nerd-fonts.fira-mono # more terminal fonts
    fira # yet more terminal fonts
    fira-code # even more terminal fonts
    fira-mono # yet still more terminal fonts
    inter # ui font
    corefonts # windows fonts
    vista-fonts # more windows fonts
  ];

  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/desktop/interface" = {
      document-font-name = "${config.fontProfiles.regular.name} ${toString config.fontProfiles.regular.size}";
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      monospace-font-name = "${config.fontProfiles.monospace.name} ${toString config.fontProfiles.monospace.size}";
    };
    "org/gnome/desktop/wm/preferences" = {
      titlebar-font = "${config.fontProfiles.regular.name} ${toString config.fontProfiles.regular.size}";
    };
  };

  fonts.fontconfig.enable = true;
}
