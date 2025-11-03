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
  ];

  # Enable flatpak and flathub
  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = ["multi-user.target"];
    path = [pkgs.flatpak];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
}
