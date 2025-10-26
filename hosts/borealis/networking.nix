{ config, lib, pkgs, ... }:

{

  networking.hostName = "borealis"; # Define your hostname.

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  # networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;

  networking.useNetworkd = true;

  networking.nftables.enable = true;

  systemd.network.enable = true;

  services.resolved = {
    # Disable local DNS stub listener on 127.0.0.53
    extraConfig = ''
      DNSStubListener=no
    '';
  };

  systemd.network.networks."10-wan" = {
    matchConfig.Name = "enp0s31f6";
    networkConfig = {
      # start a DHCP Client for IPv4 Addressing/Routing
      DHCP = "ipv4";
      # accept Router Advertisements for Stateless IPv6 Autoconfiguraton (SLAAC)
      IPv6AcceptRA = true;
    };
    # make routing on this interface a dependency for network-online.target
    linkConfig.RequiredForOnline = "routable";
  };

  networking.wireguard = {
    enable = true;
    interfaces = {
      "wgtunnelinfra" = {
#        privateKey = "SECRET_REDACTED";
        privateKeyFile = config.sops.secrets.wg_privkey_borealis.path;
        ips = ["10.10.10.3/32"];
        peers = [
          {
            name = "atlantis";
            endpoint = "aporter.xyz:51821";
            publicKey = "eYrWhvMGJc8BFadkwOhVQUQf/3OFOLiybYvE/JK7gXM=";
            allowedIPs = ["10.10.10.0/24"];
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
}
