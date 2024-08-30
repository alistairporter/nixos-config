{ config, lib, pkgs, ... }:

{
  services.samba = {
    enable = true;
    enableNmbd = true;
    enableWinbindd = true;
    nsswins = true;
    securityType = "user";
    openFirewall = true;
#    extraConfig = ''
#      workgroup = WORKGROUP
#      server string = smbnix
#      netbios name = smbnix
#      security = user 
#      #use sendfile = yes
#      #max protocol = smb2
#      # note: localhost is the ipv6 localhost ::1
#      hosts allow = 192.168.0. 127.0.0.1 localhost
#      hosts deny = 0.0.0.0/0
#      guest account = nobody
#      map to guest = bad user
#    '';
    shares = {
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
