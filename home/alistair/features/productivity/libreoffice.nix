{pkgs, ...}:{
  home.packages = with pkgs; [
    libreoffice
    hunspell
    hunspellDicts.en_GB-large
  ];
}
