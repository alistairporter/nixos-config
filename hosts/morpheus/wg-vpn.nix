{
  config,
  pkgs,
  ...
}: {
  nat = {
    enable = true;
    externalInterface = "ens6";
    internalInterfaces = ["wgtunnelvpn"];
  };

  wireguard = {
    enable = true;
    interfaces = {
      "wgtunnelinfra" = {
        privateKeyFile = config.sops.secrets.wg_privkey_morpheus_infra.path;
        ips = ["10.10.10.1/24" "fd00:dead:beef::1/128"];
        listenPort = 51821;
        postSetup = ''
          ${pkgs.iptables}/bin/iptables -A FORWARD -i wgtunnelinfra -o wgtunnelinfra -m conntrack --ctstate NEW -j ACCEPT
        '';
        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -D FORWARD -i wgtunnelinfra -o wgtunnelinfra -m conntrack --ctstate NEW -j ACCEPT
        '';
        peers = [
          {
            name = "atlantis";
            publicKey = "tTtVBxVFAfhhb5oJ7+OJIkKyAz632vn5cv6kCRRrnn4=";
            allowedIPs = ["10.10.10.2/32" "fd00:dead:beef::2/128"];
          }
          {
            name = "borealis";
            publicKey = "TjcatBBmpfBskSL6p8eEKkMqtLZ2QpLLo4OUEZP9NTo=";
            allowedIPs = ["10.10.10.3/32" "fd00:dead:beef::3/128"];
          }
          {
            name = "olympus";
            publicKey = "vXL+6bfS0uM3hpT0LYbj1GkaH+2sMk9+bYR4hydBo1M=";
            allowedIPs = ["10.10.10.4/32" "fd00:dead:beef::4/128"];
          }
          {
            name = "praclarush";
            publicKey = "VN2Qr2ShRbpGW+V8XyFjERjqiTPjytFy0ZeIZBOn7Fw=";
            allowedIPs = ["10.10.10.5/32" "fd00:dead:beef::5/128"];
          }
          {
            name = "alistairpixel5";
            publicKey = "6h3sn7Q6+E8DzpW5O7nlUt15qdIgJr+yubWB5Ev6jHo=";
            allowedIPs = ["10.10.10.6/32" "fd00:dead:beef::6/128"];
          }
        ];
      };
      "wgtunnelvpn" = {
        privateKeyFile = config.sops.secrets.wg_privkey_morpheus_vpn.path;
        ips = ["10.0.0.1/24"];
        listenPort = 51820;
        postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o ens192 -j MASQUERADE
        '';
        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.0.0.0/24 -o ens192 -j MASQUERADE
        '';
        peers = [
          {
            name = "alistairpixel5";
            publicKey = "6h3sn7Q6+E8DzpW5O7nlUt15qdIgJr+yubWB5Ev6jHo=";
            allowedIPs = ["10.0.0.2/32"];
          }
          {
            name = "alistairthinkpad";
            publicKey = "K71YVAhaQlrloPjDspnMoWiFGa7NrXOo4i7ukASaNVg=";
            allowedIPs = ["10.0.0.3/32"];
          }
          {
            name = "alistairsteamdeck";
            publicKey = "wBiOzaNwhvTEIzesU2mj9TfsbAPZpr7tTSvMKlPV9kc=";
            allowedIPs = ["10.0.0.4/32"];
          }
          {
            name = "praclarush";
            publicKey = "QApm0IY7QMXC2/KtdCooCFjXTimYVSe9bGeEUFG3/x0=";
            allowedIPs = ["10.0.0.5/32"];
          }
        ];
      };
    };
  };

  sops.secrets.wg_privkey_morpheus_infra = {
    sopsFile = ./secrets.yaml;
  };
  sops.secrets.wg_privkey_morpheus_vpn = {
    sopsFile = ./secrets.yaml;
  };

  # allow wireguard traffic through firewall.
  networking.firewall = {
    allowedTCPPorts = [config.wireguard.interfaces."wgtunnelinfra".listenPort config.wireguard.interfaces."wgtunnelvpn".listenPort];
    allowedUDPPorts = [config.wireguard.interfaces."wgtunnelinfra".listenPort config.wireguard.interfaces."wgtunnelvpn".listenPort];
  };
}
