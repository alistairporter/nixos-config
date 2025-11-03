{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./global
    ./features/desktop/gnome
  ];

  # Disable impermanence
  home.persistence = lib.mkForce {};

  # # Yellow
  # wallpaper = pkgs.inputs.themes.wallpapers.lake-houses-sunset-gold;
}
