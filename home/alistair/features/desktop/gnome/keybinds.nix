{lib, ...}: {
  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Control><Alt>t";
      command = "ptyxis --new-window";
      name = "Ptyxis";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Control><Alt>KP_Delete";
      command = "missioncenter";
      name = "Mission Center";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      binding = "<Control><Shift>Escape";
      command = "missioncenter";
      name = "Mission Center";
    };
  };
}
