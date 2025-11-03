{
  conf,
  lib,
  pkgs,
  ...
}: {
  # Enable the GNOME Desktop
  services.xserver = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
  environment.gnome.excludePackages = with pkgs; [
    epiphany # web browser
    evince # document viewer
    geary # email reader
    gnome-music
    gnome-photos
    gnome-terminal #ancient terminal emulator
    gnome-console # more modern but very spartan terminal
    yelp # gnome help
    gnome-tour
    gnome-software # not needed as using bazaar
  ];

  environment.systemPackages = with pkgs; [
    papers #use the modern version of evince
    loupe # use the modern gnome image viewer
    ptyxis # use a nicer terminal emulator than gnome-console
    argyllcms # something to try fix colour calibration
    baobab # disk usage viewer
    gnome-disk-utility # gnome disks
    gparted # gparted
    nautilus-python
    nautilus-open-any-terminal
  ];

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "ptyxis";
  };
}
