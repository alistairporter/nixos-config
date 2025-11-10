{lib, ...}: {
  services.tailscale = {
    enable = true;
    useRoutingFeatures = lib.mkDefault "client";
  };
  networking.firewall.allowedUDPPorts = [41641]; # Facilitate firewall punching
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  environment.persistence = {
    "/persist".directories = [
      {
        directory = "/var/lib/tailscale";
      }
    ];
  };
}
