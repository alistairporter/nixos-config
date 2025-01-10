{ config, lib, pkgs, ... }:

{
  services.samba = {
    enable = true;
    nmbd.enable = true;
    winbindd.enable = true;
    nsswins = true;
    settings.global.security = "user";
    openFirewall = true;
    settings = {
      Files = {
        comment = "Files on NAS";
        path = "/media/Files";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
      };
      MiscFiles = {
        comment = "Random Files";
        path = "/media/MiscFiles";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
      };
      Films = {
        comment = "reeee";
        path = "/media/Files/Multimedia/Videos/Movies";
        browseable = "yes";
        "read only" = "yes";
        "guest ok" = "yes";
      };
      TV = {
        comment = "reeee";
        path = "/media/Files/Multimedia/Videos/TV";
        browseable = "yes";
        "read only" = "yes";
        "guest ok" = "yes";
      };
      Music = {
        comment = "reeee";
        path = "/media/Files/Multimedia/Music/Music";
        browseable = "yes";
        "read only" = "yes";
        "guest ok" = "yes";
      };
    };
  };
  
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
}
