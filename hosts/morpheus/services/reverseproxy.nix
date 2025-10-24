{ config, lib, pkgs, ... }:

{
  services.haproxy = {
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

      frontend minecraft
        bind [::]:25565 v4v6
        mode tcp
        default_backend minecraft

#        frontend minecraft-voice
#          bind udp@[::]:24454 v4v6
#          default_backend minecraft-voice

      frontend forgejossh
        bind [::]:2202 v4v6
        mode tcp
        default_backend forgejossh

      backend forgejossh
        # server atlantisv4 10.10.10.2:2222
        server atlantisv4 atlantis.dropbear-monster.ts.net:2222

      backend minecraft
        # server atlantisv4 10.10.10.2:25565 check send-proxy-v2
        server atlantisv4 atlantis.dropbear-monster.ts.net:25565 check send-proxy-v2

#        backend minecraft-voice
#          server atlantisv4 udp@10.10.10.2:24454 check send-proxy-v2

      backend wireguard
        # server atlantisv4 10.10.10.2:8080 check send-proxy-v2
        server atlantisv4 atlantis.dropbear-monster.ts.net:8080 check send-proxy-v2
    '';
  };

  services.nginx = {
    enable = true;
    streamConfig = 
    ''
      #
      # Only using this for udp proxying until haproxy removes their head from their arses.
      
      # minecraft geyser
      server {
        listen 19132 udp;
        # proxy_pass 10.10.10.2:19132;
        proxy_pass atlantis.dropbear-monster.ts.net:19132;
      }
      # minecraft voice
      server {
        listen 24454 udp;
        # proxy_pass 10.10.10.2:24454;
        proxy_pass atlantis.dropbear-monster.ts.net:24454;
      }
      # minecraft voice 2
      server {
        listen 24455 udp;
        # proxy_pass 10.10.10.2:24455;
        proxy_pass atlantis.dropbear-monster.ts.net:24455;
      }
      # http3 quic
      server {
        listen 443 udp;
        proxy_pass atlantis.dropbear-monster.ts.net:443;
      }
    '';
  };

  # make proxies start after tailscale has to ensure host resolution works.
  #
  systemd.services.haproxy.after = ["tailscaled.service"];
  systemd.services.nginx.after = ["tailscaled.service"];
}
