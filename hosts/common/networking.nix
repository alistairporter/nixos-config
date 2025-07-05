{ config, lib, pkgs, ... }:

{

  services = {
    tailscale = {
      enable = true;
    };
  };

  # Tell the firewall to implicitly trust packets routed over Tailscale:
  networking.firewall.trustedInterfaces = [ "tailscale0" ];


  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "prohibit-password";
    };
  };

  
  services.avahi = {
    enable = true;
    ipv4 = true;
    ipv6 = true;
    nssmdns4 = true;
    nssmdns6 = true;
    openFirewall = true;
    extraServiceFiles = {
      ssh = "${pkgs.avahi}/etc/avahi/services/ssh.service";
    };
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
      hinfo = true;
      domain = true;
      userServices = true;
    };
  };
}
