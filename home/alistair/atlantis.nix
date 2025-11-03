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

  # # Yellow
  # wallpaper = pkgs.inputs.themes.wallpapers.lake-houses-sunset-gold;
}
