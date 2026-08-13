{
  config,
  lib,
  pkgs,
  private,
  ...
}: let
  atlantis = "atlantis.${private.tailnet}";
in {
  services.haproxy = {
    enable = true;
    config = ''
      frontend http
        mode http
        bind [::]:80 v4v6
        redirect scheme https code 301

      frontend https
        bind [::]:443 v4v6
        mode tcp
        default_backend httpsbackend

      frontend prometheus
        bind :8405
        mode http
        http-request use-service prometheus-exporter
        no log

      frontend minecraft
        bind [::]:25565 v4v6
        mode tcp
        default_backend minecraftbackend

      frontend forgejossh
        bind [::]:2202 v4v6
        mode tcp
        default_backend forgejosshbackend

      backend forgejosshbackend
        # server atlantisv4 10.10.10.2:2222
        server atlantisv4 ${atlantis}:2222

      backend minecraftbackend
        # server atlantisv4 10.10.10.2:25565 check send-proxy-v2
        server atlantisv4 ${atlantis}:25565 check send-proxy-v2

      backend httpsbackend
        # server atlantisv4 10.10.10.2:8080 check send-proxy-v2
        server atlantisv4 ${atlantis}:8080 check send-proxy-v2
    '';
  };

  services.nginx = {
    enable = true;
    streamConfig = ''
      #
      # Only using this for udp proxying until haproxy removes their head from their arses.

      # minecraft geyser
      server {
        listen 19132 udp;
        # proxy_pass 10.10.10.2:19132;
        proxy_pass ${atlantis}:19132;
      }
      # minecraft voice
      server {
        listen 24454 udp;
        # proxy_pass 10.10.10.2:24454;
        proxy_pass ${atlantis}:24454;
      }
      # minecraft voice 2
      server {
        listen 24455 udp;
        # proxy_pass 10.10.10.2:24455;
        proxy_pass ${atlantis}:24455;
      }
    '';
  };

  networking.firewall = {
    allowedUDPPorts = [
      19132 # minecraft bedrock udp
      24454 # minecraft voice
      24455 # minecraft voice 2
    ];
    allowedTCPPorts = [
      80 # http
      443 # https
      2202 # gitea hackery
      9100 # prometheus node exporter
      19132 # minecraft bedrock tcp
      25565 # minecraft java
    ];
  };
  # make proxies start after tailscale has to ensure host resolution works.
  #
  systemd.services.haproxy.after = ["tailscaled.service"];
  systemd.services.nginx.after = ["tailscaled.service"];
}
