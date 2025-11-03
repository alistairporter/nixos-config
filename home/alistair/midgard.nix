{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./global
    ./features/desktop/gnome
    ./features/productivity
    ./features/games
  ];

  # Disable impermanence
  home.persistence = lib.mkForce {};

  # # Yellow
  # wallpaper = pkgs.inputs.themes.wallpapers.lake-houses-sunset-gold;
}
