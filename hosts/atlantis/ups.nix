{ config, ... }:{
  power.ups = {
    enable = true;
    mode = "netserver";
    openFirewall = true;
    users = {
      "admin" = {
        passwordFile = config.sops.secrets.nut_admin_password.path;
        actions = ["set" "fsd"];
        instcmds = [ "all" ];
        upsmon = "primary";
      };
      "observer" = {
        passwordFile = config.sops.secrets.nut_observer_password.path;
        upsmon = "secondary";
      };
    };
    ups."serverups" = {
      driver = "usbhid-ups";
      port = "auto";
      description = "Server UPS";
    };
    upsmon.monitor."serverups".user = "observer";
    upsd.listen = [
      {
        address = "::";
      }
      {
        address = "0.0.0.0";
      }
    ];
  };
  sops.secrets.nut_admin_password = {
    sopsFile = ./secrets.yaml;
  };
  sops.secrets.nut_observer_password = {
    sopsFile = ./secrets.yaml;
  };
}
