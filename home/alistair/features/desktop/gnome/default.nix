{pkgs, ...}:{
  imports = [
    ../common
    ./extensions.nix
    ./shell.nix
    ./wm.nix
    ./keybinds.nix
    ./nautilus.nix
    ./extensions.nix
  ];
  # Enable xdg-desktop-portal and GTK backend
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];

    config = {
      common.default = [ "gnome" "gtk" ];
    };
  };
}
