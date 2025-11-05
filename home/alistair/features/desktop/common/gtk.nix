{
  config,
  pkgs,
  lib,
  ...
}: {
  gtk = {
    enable = true;
    font = {
      inherit (config.fontProfiles.regular) name size;
    };
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    cursorTheme = {
      name = "Posy_Cursor_Black";
      package = pkgs.posy-cursors;
    };
    iconTheme = {
      name = "MoreWaita";
      package = pkgs.morewaita-icon-theme;
    };
    gtk3 = {
      extraConfig.gtk-application-prefer-dark-theme = true;
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    hyprcursor.enable = true;
    x11.enable = true;
    name = "Posy_Cursor_Black";
    package = pkgs.posy-cursors;
    size = 32;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "${config.gtk.theme.name}";
      cursor-size = config.home.pointerCursor.size;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  home.sessionVariables = {
    # For qadwaitadecorations
    QT_WAYLAND_DECORATION = "adwaita";    
  };

  home.packages = with pkgs; [
    # Fix Qt app client decorations
    qadwaitadecorations
    qadwaitadecorations-qt6
  ];
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
}
