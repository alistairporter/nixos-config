{ config, lib, pkgs, ... }:

{
  # Hardware:
  ## nvidia stuff
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia.open = true;
  hardware.nvidia-container-toolkit.enable = true;
  hardware.graphics.enable = true;
  
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

  # custom.server.watchdogd.enable = true;
  custom.server.scheduledreboot = {
    enable = false;
    time = "04:00:00";
  };

  # services.watchdogd = {
  #   enable = true;
  #   settings = {
  #     "ping" = "1.1.1.1";
  #     # "ping" = "8.8.8.8";
  #   };
  # };

#  ## apcupsd for ups
#  services.apcupsd = {
#    enable = false;
#    configText = ''
#      UPSCABLE usb
#      UPSTYPE usb
#      NISIP 0.0.0.0
#      MINUTES 10
#    '';
#  };
}
