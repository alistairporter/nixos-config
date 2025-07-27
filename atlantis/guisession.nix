{ config, lib, pkgs, ... }:

{
  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  services.xserver.videoDrivers = [ "intel" "nvidia" ];

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # xrdp stuff
  services.xserver.desktopManager.xfce.enable = true;
  services.xrdp = {
    enable = true;
#    defaultWindowManager = "${pkgs.xfce4-session}/bin/xfce4-session";
    defaultWindowManager = "xfce4-session";
    audio.enable = true;
  };
  
  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };
  
  # XDG stuff 
  xdg = {
    portal.enable = true;
    portal.extraPortals = [ pkgs.xdg-desktop-portal-xapp pkgs.xdg-desktop-portal-gtk ];
    terminal-exec.enable = true;
  };
}
