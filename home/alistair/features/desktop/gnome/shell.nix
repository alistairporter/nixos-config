{
  lib,
  ...
}:
{
  
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      clock-show-seconds = true;
      clock-show-weekday = true;
      enable-animations = true;
      enable-hot-corners = true;
      show-battery-percentage = true;
    };

    "org/gnome/desktop/peripherals/keyboard" = {
      numlock-state = true;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      disable-while-typing = false;
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/search-providers" = {
      disabled = [ "org.gnome.Software.desktop" ];
      enabled = [ "io.github.kolunmi.Bazaar.desktop" "org.gnome.Weather.desktop" ];
      sort-order = [ "org.gnome.Contacts.desktop" "org.gnome.Documents.desktop" "org.gnome.Nautilus.desktop" ];
    };

    "org/gnome/shell" = {
      # Dock apps in dash
      favorite-apps = [ "zen-beta.desktop" "thunderbird.desktop" "bitwarden.desktop" "obsidian.desktop" "steam.desktop" "org.remmina.Remmina.desktop" "org.gnome.Ptyxis.desktop" "vlc.desktop" "org.gnome.Nautilus.desktop" "org.gnome.Settings.desktop" ];
      last-selected-power-profile = "performance";
      remember-mount-password = true;
    };

    "org/gnome/shell/app-switcher" = {
      current-workspace-only = false;
    };

    "org/gnome/shell/window-switcher" = {
      current-workspace-only = false;
    };
    
    "org/gnome/desktop/sound" = {
      allow-volume-above-100-percent = true;
    };
  };
}
