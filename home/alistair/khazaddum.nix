{
  inputs,
  lib,
  ...
}: {
  imports = [
    ./global
    ./features/desktop/gnome
  ];

  # Disable impermanence
  home.persistence = lib.mkForce {};

  targets.genericLinux.enable = true;
  nixGL = {
    packages = inputs.nix-gl.packages;
    defaultWrapper = "mesa";
    installScripts = ["mesa"];
    vulkan.enable = true;
  };
  # # Yellow
  # wallpaper = pkgs.inputs.themes.wallpapers.lake-houses-sunset-gold;
}
