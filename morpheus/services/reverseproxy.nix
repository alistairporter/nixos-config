{ config, lib, pkgs, ... }:

{
  services = {
  
    haproxy = {
      enable = true;
      config =
      ''
        frontend http                                                                                                                                            
          mode http
          bind :80
          redirect scheme https code 301

        frontend https
          bind *:443
          mode tcp
          default_backend wireguard

        backend wireguard
          server s1 10.10.10.2:8080 check send-proxy-v2
      '';
    };
    
    nginx = {
      enable = true;
      streamConfig = 
      ''
        # gitea stuff
        upstream atlantisgitea-ssh {
          server 10.10.10.2:2222;
        }
        server {
          listen 2202;
          proxy_pass atlantisgitea-ssh;
        }

        # minecraft

        server {
          listen 25565;
          proxy_pass 10.10.10.2:25565;
        }
        server {
          listen 19132 udp;
          proxy_pass 10.10.10.2:19132;
        }
      '';
    };
  };
}
