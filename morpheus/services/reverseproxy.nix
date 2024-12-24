{ config, lib, pkgs, ... }:

{
  services = {
  
    haproxy = {
      enable = true;
      config =
      ''
        frontend http                                                                                                                                            
          mode http
          bind [::]:80 v4v6
          redirect scheme https code 301

        frontend https
          bind [::]:443 v4v6
          mode tcp
          default_backend wireguard

        frontend mc
          bind [::]:25565 v4v6
          mode tcp
          default_backend minecraft

        frontend forgejossh
          bind [::]:2202 v4v6
          mode tcp
          default_backend forgejossh

        backend forgejossh
          server atlantis 10.10.10.2:2222

        backend minecraft
          server s1 10.10.10.2:25565 check send-proxy-v2

        backend wireguard
          server s1 10.10.10.2:8080 check send-proxy-v2
      '';
    };
  };
}
