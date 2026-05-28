{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./global
    ./features/desktop/xfce
  ];

  # Disable impermanence
  home.persistence = lib.mkForce {};

  # This needs compiling from src, only use on systems where absolutely needed
  home.packages = with pkgs; [
    clementine # media player with decent mp3player and ipod support
  ];

  # # Yellow
  # wallpaper = pkgs.inputs.themes.wallpapers.lake-houses-sunset-gold;
}
