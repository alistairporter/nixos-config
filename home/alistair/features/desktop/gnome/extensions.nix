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
      gamemode-shell-extension
      gsconnect
      just-perfection
      logo-menu
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
      gamemode-shell-extension.extensionUuid
      gsconnect.extensionUuid
      just-perfection.extensionUuid
      logo-menu.extensionUuid
      quick-settings-audio-panel.extensionUuid
      quick-touchpad-toggle.extensionUuid
      tactile.extensionUuid
      tailscale-status.extensionUuid
      user-themes.extensionUuid
      user-avatar-in-quick-settings.extensionUuid
    ];
  };

  dconf.settings."org/gnome/shell/extensions/Logo-menu" = {
    menu-button-icon-click-type = 2;
    menu-button-icon-image = 23;
    menu-button-software-center = "flatpak run io.github.kolunmi.Bazaar";
    menu-button-system-monitor = "missioncenter";
    menu-button-terminal = "xdg-terminal-exec";
    show-activities-button = true;
    symbolic-icon = true;
    use-custom-icon = false;
  };

  dconf.settings."org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
    blur = false;
  };

  dconf.settings."org/gnome/shell/extensions/blur-my-shell/panel" = {
    blur = false;
  };
  
  dconf.settings."org/gnome/shell/extensions/dash-to-dock" = {
    apply-custom-theme = true;
    custom-theme-shrink = true;
    dash-max-icon-size = 64;
    disable-overview-on-startup = false;
    dock-position = "BOTTOM";
    require-pressure-to-show = true;
    show-mounts = false;
    show-show-apps-button = false;
    show-trash = false;
  };

  dconf.settings."org/gnome/shell/extensions/freon" = {
    show-decimal-value = false;
    show-icon-on-panel = false;
    show-rotationrate-unit = true;
  };

  dconf.settings."org/gnome/shell/extensions/search-light" = {
    shortcut-search = [ "<Super>space" ];
    popup-at-cursor-monitor = true;
  };
}
