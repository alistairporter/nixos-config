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

  # Add machine specific Bookmarks for gtk3/nautilus
  gtk.gtk3.bookmarks = [
    "file:///media/Games01 Games01 On SSD1"
    "file:///media/Games02 Games02 On SSD2"
    "file:///mnt/SSD1"
    "file:///mnt/SSD2"
  ];
  
  # # Yellow
  # wallpaper = pkgs.inputs.themes.wallpapers.lake-houses-sunset-gold;
}
