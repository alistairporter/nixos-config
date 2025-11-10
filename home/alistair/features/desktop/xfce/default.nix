{pkgs, ...}: {
  imports = [
    ../common
  ];
  
  home.packages = with pkgs; [
    adw-xfwm4
    xfce.xfce4-icon-theme
    xfce.xfdesktop
  ];

  # xfconf.settings = {
  #   xfwm4 = {
  #     "/general/theme" = "adw-gtk3-dark";
  #     "/general/activate_action" = "none";
  #   };

  #   xfce4-desktop = {
  #     "/desktop-icons/file-icons/show-unknown-removable" = false;
  #     "/desktop-icons/file-icons/show-device-fixed" = false;
  #   };
  # };

  # Enable xdg-desktop-portal and GTK backend
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-xapp
      xdg-desktop-portal-gtk
    ];

    config = {
      common.default = ["xapp" "gtk"];
    };

  };
}
