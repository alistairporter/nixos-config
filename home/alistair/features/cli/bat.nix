{
  pkgs,
  ...
}:{
  # better cat
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [ batdiff batman batgrep batwatch batpipe];
  };
}
