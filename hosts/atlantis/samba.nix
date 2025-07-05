{ inputs, config, lib, pkgs, ...}:

let
  cfg = config.custom.atlantis.samba;
in {
  options.custom.atlantis.samba = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "enable samba server for atlantis";
    };
  };
  config = lib.mkIf cfg.enable {
  
    #
    # SAMBA server:
    #
    services.samba = {
      enable = true;
      nmbd.enable = false;
      winbindd.enable = false;
      nsswins = false;
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

    services.avahi.extraServiceFiles.smb = ''
      <?xml version="1.0" standalone='no'?><!--*-nxml-*-->
      <!DOCTYPE service-group SYSTEM "avahi-service.dtd">

      <service-group>
      <name replace-wildcards="yes">%h</name>
      <service>
      <type>_smb._tcp</type>
      <port>445</port>
      </service>
      </service-group>
    '';
  };
}
