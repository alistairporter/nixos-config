{ config, lib, pkgs, ... }:

{
  services = {
    prometheus.exporters.node = {
      enable = true;
    };

    netdata = {
      config = {
        global = { "memory mode" = "none"; };
        web = {
          mode = "none";
          "accept a streaming request every seconds" = 0;
        };
      };
      configDir = {
        "stream.conf" = pkgs.writeText "stream.conf" ''
          [stream]
            enabled = yes
            destination = 10.10.10.2:19999
            api key = 3d560d1c-edee-4557-8f2f-e31d1335aa5b
        '';
      };
    };
  };
}
