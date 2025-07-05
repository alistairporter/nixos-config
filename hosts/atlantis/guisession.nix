{ config, lib, pkgs, ... }:

{
#
# RDP via xrdp with some gui niceties and plenty of hacky rubbish and bodges.
#
  # x11 bullrubbish.
  services.xserver.videoDrivers = [ "intel" "nvidia" ];

  # Enable sound.
  hardware.pulseaudio.enable = true; # theres no xrdp pipewire support in nixpkgs as of 2024 so pipewire it is.
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # xrdp stuff
  services.xserver.desktopManager.xfce.enable = true;
  services.xrdp = {
    enable = true;
    audio.enable = true;
    defaultWindowManager = "xfce4-session";
  };

  # XDG stuff 
  xdg = {
    portal.enable = true;
    portal.extraPortals = [ pkgs.xdg-desktop-portal-xapp pkgs.xdg-desktop-portal-gtk ];
    terminal-exec.enable = true;
  };

  #
  # disable the endless authentication prompts in the gui, once is reasonable twenty in a row is not.
  # yes this is a bad idea, but if someone has access to my server over rdp, which is not exposed to the internet, I have bigger fish to fry than this.
  security.polkit = {
    enable = true;
    debug = true;
    extraConfig =  ''
        /* Log authorization checks. */
        polkit.addRule(function(action, subject) {
          // Make sure to set { security.polkit.debug = true; } in configuration.nix
          polkit.log("user " +  subject.user + " is attempting action " + action.id + " from PID " + subject.pid);
        });

        polkit.addRule(function(action, subject) {
          if (subject.isInGroup("wheel")) {
            return "yes";
          }
        });
        /* Allow any local user to do anything (dangerous!). */
        polkit.addRule(function(action, subject) {
          if (subject.local) return "yes";
        });
      '';
  };

  
  # flatpak
  services.flatpak.enable = true;

  # Packages that are only useful in a gui 
  environment.systemPackages = with pkgs; [
    flatpak
    firefox
    calibre
    gnome-software
    gnome-disk-utility
    baobab
  ];
}
