{pkgs, ...}:{
  imports = [
    ../common
  ];
  # Enable xdg-desktop-portal and GTK backend
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-xapp
      xdg-desktop-portal-gtk
    ];

    config = {
      common.default = [ "xapp" "gtk" ];
    };
  };
}
