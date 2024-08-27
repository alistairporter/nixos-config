{ config, lib, pkgs, ... }:

{
  # Networking:
  networking.hostName = "atlantis";
#  networking.networkmanager.enable = true;
  networking.wireguard = {
    enable = true;
    interfaces = {
      "wgtunnelatl" = {
        privateKey = "SECRET_REDACTED";
        ips = ["10.10.10.2/32"];
        peers = [
          {
            name = "atlantis";
            endpoint = "aporter.xyz:51821";
            publicKey = "eYrWhvMGJc8BFadkwOhVQUQf/3OFOLiybYvE/JK7gXM=";
            allowedIPs = ["10.10.10.1/32"];
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
}
