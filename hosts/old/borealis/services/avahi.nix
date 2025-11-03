{
  config,
  lib,
  pkgs,
  ...
}: {
  services.avahi = {
    enable = true;
    ipv4 = true;
    ipv6 = true;
    nssmdns4 = true;
    nssmdns6 = true;
    openFirewall = true;
    allowInterfaces = ["enp0s31f6" "lo"];
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
