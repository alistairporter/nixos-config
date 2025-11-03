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

  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
}
