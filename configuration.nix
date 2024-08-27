{ config, pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  users.users.alistair = {
    extraGroups = ["wheel" "networkmanager" "docker"];
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.zsh;
    hashedPassword = "SECRET_REDACTED";
  };
  users.users.root.openssh.authorizedKeys.keys = [''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCmXutLfqemWt5DqhrgIp+8xqvjw1hNmQ3U8tDWDrc89LpvUx2wIwiekUgXTa3XrfYd/PjrJnhN1N9XPCb0Fer5dp4fzZY74SepnqV2aBiOopAWiVP3ZWT48SGvM5OX26YiDOpHkfOCBLPhrBPlqLSoblHnvedzsR5V0oO62dEfgVPmSTnZRZERvfNdidVVJMODYiFeco3aFeX425FloGsjIuSDPCIu/u+iJFdNjpDah+nEsHWOuIDuIG3uvPkYWusFbuctQ6lL5I3QIJC2i++h+OvGMszPm8EH8P9KH3t+AfobudHDb5WRthdfDtWaig63tyiQrAxFZVsqDvhp/VEU0ZVQBgs2a1KV3sCpFM3rZX9lTBykthFsJvKDTj7G0fiO7Z0O1a0ajvcoPbu/WRe9PsyK7wgnz5HGMWcNFdLnFkXL51Q08jBC7/GAXsfJsw0zai22G9E0BRHQPiEjBC4CpCHWoIfXc//ife14z62DpiKm8HaDy5ZVLDoTX4Z+Dok= alistair@midgard'' ];

  networking = {
    hostName = "morpheus";
    domain = "";
    firewall = {
      allowedUDPPorts = [
        19132 # minecraft bedrock udp
        51820 # wireguard vpn udp
        51821 # wireguard server tunnel udp
        51822 # wireguard docker udp
        54914 # transmission peer?
      ];
      allowedTCPPorts = [
        22    # ssh
        80    # http
        443   # https
        2202  # gitea hackery
        9100  # prometheus node exporter
        19132 # minecraft bedrock tcp
        25565 # minecraft java
        51820 # wireguard vpn tcp
        51821 # wireguard server tcp
        51822 # wireguard docker tcp
      ];
    };
    nat = {
      enable = true;
      externalInterface = "ens6";
      internalInterfaces = [ "wgtunnelvpn" ];
    };
    wireguard = {
      enable = true;
      interfaces = {
        "wgtunnelatl" = {
          privateKey = "SECRET_REDACTED";
          ips = ["10.10.10.1/24"];
          listenPort = 51821;
          peers = [
            {
              name = "atlantis";
              publicKey = "tTtVBxVFAfhhb5oJ7+OJIkKyAz632vn5cv6kCRRrnn4=";
              allowedIPs = ["10.10.10.2/32"];
            }
            {
              name = "olympus";
              publicKey = "vXL+6bfS0uM3hpT0LYbj1GkaH+2sMk9+bYR4hydBo1M=";
              allowedIPs = ["10.10.10.3/32"];
            }
          ];
        };
        "wgtunnelvpn" = {
          privateKey = "SECRET_REDACTED";
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
              name ="alistairsteamdeck";
              publicKey = "wBiOzaNwhvTEIzesU2mj9TfsbAPZpr7tTSvMKlPV9kc=";
              allowedIPs = ["10.0.0.4/32"];
            }
          ];
        };
      };
    };
  };

  time.timeZone = "Europe/London";

  services = {
    openssh = {
      enable = true;
      settings.PasswordAuthentication = true;
      settings.PermitRootLogin = "no";
#      moduliFile = "";
      extraConfig = "StreamLocalBindUnlink yes";
    };
    prometheus.exporters.node = {
      enable = true;
    };
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

  environment.systemPackages = with pkgs; [
    docker-compose
    tmux
    git
    vim
    wget
    htop
    neofetch
    zsh
    atuin
    starship
    iptables
    gnupg
    pinentry
    pinentry-curses
    prometheus-node-exporter
  ];

  programs = {
    dconf.enable = true;
    zsh.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  virtualisation = {
    vmware.guest.enable = true;
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };

  system = {
    stateVersion = "23.11";
    autoUpgrade = {
      enable = true;
      allowReboot = true;
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes"];
}  
