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
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "${config.gtk.theme.name}";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };

  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
}
