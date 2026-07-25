{
  pkgs,
  config,
  inputs,
  private,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix
    ./filesystems.nix
    ./ups.nix
    ./services

    ../common/global
    ../common/users/alistair

    ../common/optional/systemd-boot.nix
    ../common/optional/tailscale-exit-node.nix
    ../common/optional/docker.nix
    ../common/optional/gpustuff.nix
    ../common/optional/incus.nix
    ../common/optional/xrdp-xfce.nix
    ../common/optional/avahi.nix
    ../common/optional/flatpak.nix
  ];

  networking = {
    hostName = "atlantis";
    useDHCP = true;
    useNetworkd = true;
    nftables.enable = true;
  };

  systemd.network = {
    enable = true;
    networks."10-wan" = {
      matchConfig.Name = "eno1";
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };

  networking.firewall.allowedTCPPorts = [
    9091 # transmission
    51414 # transmission peers
    9100 # prometheus
    9323 # docker metrics
    8266 # tdarr
  ];

  networking.wireguard = {
    enable = true;
    interfaces = {
      "wgtunnelinfra" = {
        privateKeyFile = config.sops.secrets.wg_privkey_atlantis.path;
        ips = ["10.10.10.2/32" "fd00:dead:beef::2/128"];
        peers = [
          {
            name = "atlantis";
            endpoint = "${private.domain}:51821";
            publicKey = "eYrWhvMGJc8BFadkwOhVQUQf/3OFOLiybYvE/JK7gXM=";
            allowedIPs = ["10.10.10.0/24" "fd00:dead:beef::1/112"];
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };
  sops.secrets.wg_privkey_atlantis = {
    sopsFile = ./secrets.yaml;
  };

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;
    kernelModules = ["nct6775"];
    binfmt.emulatedSystems = [
      "aarch64-linux"
      "i686-linux"
    ];
  };

  environment.systemPackages = with pkgs; [
    calibre
    mergerfs
    mergerfs-tools
  ];

  # btrfs array dropout monitoring
  custom.server.btrfs-monitor = {
    enable = true;
    mountpoints = ["/media/Files" "/media/MiscFiles"];
    webhook = {
      headers = {
        Priority = "high";
        Tags = "warning,floppy_disk";
      };
      # URL is supplied via BTRFS_MONITOR_WEBHOOK_URL in the sops secret below.
      environmentFile = config.sops.secrets.btrfs_monitor_webhook.path;
    };
  };
  sops.secrets.btrfs_monitor_webhook = {
    sopsFile = ./secrets.yaml;
  };

  # Scrutiny Collector
  services.scrutiny.collector = {
    enable = true;
    settings = {
      log.level = "INFO";
      api.endpoint = "http://atlantis:8081";
    };
  };

  # Beszel Agent:
  #
  services.beszel.agent = {
    enable = true;
    openFirewall = true;
    environment = {
      "EXTRA_FILESYSTEMS" = "/media/MiscFiles,/media/Files";
    };
    environmentFile = "${config.sops.secrets.beszel_key_atlantis.path}";
  };
  sops.secrets.beszel_key_atlantis = {
    sopsFile = ./secrets.yaml;
  };

  hardware.graphics.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia.open = true;
  hardware.nvidia-container-toolkit.enable = true;

  security.polkit = {
    enable = true;
    extraConfig = ''
      /* Log authorization checks. */
      polkit.addRule(function(action, subject) {
        // Make sure to set { security.polkit.debug = true; } in configuration.nix
        polkit.log("user " +  subject.user + " is attempting action " + action.id + " from PID " + subject.pid);
      });

      polkit.addRule(function(action, subject) {
        if (subject.isInGroup("wheel")) {
          return "yes";
        }
      });
      /* Allow any local user to do anything (dangerous!). */
      polkit.addRule(function(action, subject) {
        if (subject.local) return "yes";
      });
    '';
  };

  system.stateVersion = "24.05";
}
