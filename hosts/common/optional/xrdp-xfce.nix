{
  config,
  lib,
  pkgs,
  ...
}: {
  # Enable x drivers to _hopefully_ support hadware compositing?
  services.xserver.videoDrivers = ["intel" "nvidia"];

  # Enable sound for xrdp session, doesn't yet support pipewire as of 20251101 :(
  services.pulseaudio.enable = true;

  # setup XFCE environment for xrdp session.
  services.xserver.desktopManager.xfce.enable = true;

  # Enable XRDP service
  services.xrdp = {
    enable = true;
    openFirewall = true;
    # use xfce as session
    defaultWindowManager = "xfce4-session";
    # use pulseaudio module to support audio forwarding
    audio.enable = true;
  };

  # Set some extra XDG stuff to get portals mostly working as not using proper session.
  xdg = {
    portal.enable = true;
    portal.extraPortals = [pkgs.xdg-desktop-portal-xapp pkgs.xdg-desktop-portal-gtk];
    terminal-exec.enable = true;
  };
}
