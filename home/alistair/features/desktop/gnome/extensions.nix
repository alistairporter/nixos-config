{
  lib,
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs.gnomeExtensions; [
      alphabetical-app-grid
      appindicator
      blur-my-shell
      caffeine
      dash-to-dock
      freon
      fuzzy-app-search
      gsconnect
      just-perfection
      quick-settings-audio-panel
      quick-touchpad-toggle
      tactile
      tailscale-status
      user-themes
      user-avatar-in-quick-settings
  ];
  
  dconf.settings."org/gnome/shell" = {
    disable-user-extensions = false;
    enabled-extensions = with pkgs.gnomeExtensions; [
      alphabetical-app-grid.extensionUuid
      appindicator.extensionUuid
      blur-my-shell.extensionUuid
      caffeine.extensionUuid
      dash-to-dock.extensionUuid
      freon.extensionUuid
      fuzzy-app-search.extensionUuid
      gsconnect.extensionUuid
      just-perfection.extensionUuid
      quick-settings-audio-panel.extensionUuid
      quick-touchpad-toggle.extensionUuid
      tactile.extensionUuid
      tailscale-status.extensionUuid
      user-themes.extensionUuid
      user-avatar-in-quick-settings.extensionUuid
    ];
  };
}
