# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./filesystems.nix
      ./usersandgroups.nix
      ./packages.nix
      ./virtualisation.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hardware:
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia-container-toolkit.enable = true;
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Networking:
  networking.hostName = "atlantis";
#  networking.networkmanager.enable = true;
  networking.wireguard = {
    enable = true;
    interfaces = {
      "wgtunnelatl" = {
        privateKey = "SECRET_REDACTED";
        ips = ["10.10.10.2/32"];
        peers = [
          {
            name = "atlantis";
            endpoint = "aporter.xyz:51821";
            publicKey = "eYrWhvMGJc8BFadkwOhVQUQf/3OFOLiybYvE/JK7gXM=";
            allowedIPs = ["10.10.10.1/32"];
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  services.xserver.videoDrivers = [ "intel" "nvidia" ];

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  services.avahi = {
    enable = true;
    ipv4 = true;
    ipv6 = true;
    nssmdns4 = true;
    nssmdns6 = true;
    openFirewall = true;
    allowInterfaces = [ "eno1" "lo" ];
    extraServiceFiles = {
      ssh = "${pkgs.avahi}/etc/avahi/services/ssh.service";
      smb = ''
        <?xml version="1.0" standalone='no'?><!--*-nxml-*-->
        <!DOCTYPE service-group SYSTEM "avahi-service.dtd">

        <service-group>
        <name replace-wildcards="yes">%h</name>
        <service>
        <type>_smb._tcp</type>
        <port>445</port>
        </service>
        </service-group>
        '';
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

  # xrdp stuff
  services.xserver.desktopManager.xfce.enable = true;
  services.xrdp = {
    enable = true;
#    defaultWindowManager = "${pkgs.xfce4-session}/bin/xfce4-session";
    defaultWindowManager = "xfce4-session";
  };

  # flatpak
  services.flatpak.enable = true;
  
  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.zsh.enable = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  # Scrutiny Collector 
  services.scrutiny.collector = {
    enable = true;
    settings = {
      log.level = "INFO";
      api.endpoint = "http://10.10.10.2:8081";
    };
  };
  
  # Prometheus Collector
  services.prometheus.exporters.node.enable = true; 

  # Netdata
  systemd.services.netdata.path = [pkgs.linuxPackages.nvidia_x11 pkgs.smartmontools pkgs.apcupsd pkgs.jq];
  systemd.services.netdata.serviceConfig.CapabilityBoundingSet = ["CAP_SETGID" "CAP_DAC_OVERRIDE" "CAP_DAC_READ_SEARCH" "CAP_FOWNER" "CAP_SYS_RAWIO" "CAP_SETPCAP" "CAP_SYS_ADMIN" "CAP_PERFMON" "CAP_SYS_PTRACE" "CAP_SYS_RESOURCE" "CAP_NET_RAW" "CAP_SYS_CHROOT" "CAP_NET_ADMIN" "CAP_SETGID" "CAP_SETUID" "CAP_CHOWN"];
  services.netdata = {
    enable = true;
    config = {
      global = {
        "history" = 3600;
      };
      plugins = {
        "ebpf" = "yes";
      };
      ml."enabled" = "yes";
    };
    configDir = {
      "stream.conf" =
        let
          mkChildNode = apiKey: allowFrom: ''
            [${apiKey}]
              enabled = yes
              default history = 3600
              default memory mode = dbengine # a good default
              health enabled by default = auto
              allow from = ${allowFrom}
          '';
        in pkgs.writeText "stream.conf" ''
          [stream]
            # This won't stream by itself, except if the receiver is a sender too, which is possible in netdata model.
            enabled = no
            enable compression = yes

          # Morpheus
          ${mkChildNode "3d560d1c-edee-4557-8f2f-e31d1335aa5b" "10.10.10.1"}

          #
          ${mkChildNode "e3a6ddf5-b14a-40c5-85fe-88db72c767d5" "192.168.1.* *"}

          #
          ${mkChildNode "0fb8487b-a29b-4786-a29d-a89a27e0f000" "192.168.1.* *"}
        '';
      "health_alarm_notify.conf" = pkgs.writeText "health_alarm_notify.conf" ''
        SEND_GOTIFY="YES"
        GOTIFY_APP_TOKEN="A1Rce9myhGXN7sX"
        GOTIFY_APP_URL="https://gotify.aporter.xyz"
      '';
      "python.d.conf" = pkgs.writeText "python.d.conf" ''
        nvidia_smi: yes
      '';
      "charts.d/apcupsd.conf" = pkgs.writeText "charts.d/apcupsd.conf" ''
        declare -A apcupsd_sources=(
          ["atlantis"]="127.0.0.1:3551"
        )
      '';
      "go.d/docker.conf" = pkgs.writeText "go.d/docker.conf" ''
        jobs:
          - name: local
            address: 'unix:///var/run/docker.sock'
            timeout: 2
            collect_container_size: yes
#          - name: localtcp
#            address: 'tcp://10.10.10.2:2375'
      '';
      "ebpf.d.conf" = pkgs.writeText "ebpf.d.conf" ''
        [global]
          ebpf load mode = entry
          apps = yes
          cgroups = yes
          update every = 5
          pid table size = 32768
          btf path = /sys/kernel/btf/

        [ebpf programs]
          cachestat = no
          dcstat = no
          disk = no
          fd = yes
          filesystem = yes
          hardirq = yes
          mdflush = no
          mount = yes
          oomkill = yes
          process = yes
          shm = no
          socket = yes
          softirq = yes
          sync = yes
          swap = no
          vfs = yes
          network connections = yes
      '';
      "go.d.conf" = pkgs.writeText "go.d.conf" ''
        enabled: yes
        default_run: yes
        max_procs: 0
        modules:
          nvidia-smi: yes
          smartctl: yes
      '';
      "health.d/go.d.conf" = pkgs.writeText "go.d.conf" ''
        # get netdata to stfu about full MDX Disks

        alarm: disk_space_usage
           on: disk_space._mnt_data_md1
         calc: $used * 100 / ($avail + $used)
        units: %
        every: 1m
         warn: $this > (($status >= $WARNING ) ? (99) : (99))
         crit: $this > (($status == $CRITICAL) ? (100) : (100))
        delay: up 1m down 15m multiplier 1.5 max 1h
         info: current disk space usage
           to: sysadmin
#        warn: 0
#        crit: 0

        alarm: disk_space_usage
           on: disk_space._mnt_data_md2
         calc: $used * 100 / ($avail + $used)
        units: %
        every: 1m
         warn: $this > (($status >= $WARNING ) ? (99) : (99))
         crit: $this > (($status == $CRITICAL) ? (100) : (100))
        delay: up 1m down 15m multiplier 1.5 max 1h
         info: current disk space usage
           to: sysadmin
#        warn: 0
#        crit: 0
 
        alarm: disk_space_usage
           on: disk_space._mnt_data_md3
         calc: $used * 100 / ($avail + $used)
        units: %
        every: 1m
         warn: $this > (($status >= $WARNING ) ? (99) : (99))
         crit: $this > (($status == $CRITICAL) ? (100) : (100))
        delay: up 1m down 15m multiplier 1.5 max 1h
         info: current disk space usage
           to: sysadmin
#        warn: 0
#        crit: 0
 
        alarm: disk_space_usage
           on: disk_space._mnt_data_md4
         calc: $used * 100 / ($avail + $used)
        units: %
        every: 1m
         warn: $this > (($status >= $WARNING ) ? (99) : (99))
         crit: $this > (($status == $CRITICAL) ? (100) : (100))
        delay: up 1m down 15m multiplier 1.5 max 1h
         info: current disk space usage
           to: sysadmin
#        warn: 0
#        crit: 0
 
        alarm: disk_space_usage
           on: disk_space._mnt_data_md5
         calc: $used * 100 / ($avail + $used)
        units: %
        every: 1m
         warn: $this > (($status >= $WARNING ) ? (99) : (99))
         crit: $this > (($status == $CRITICAL) ? (100) : (100))
        delay: up 1m down 15m multiplier 1.5 max 1h
         info: current disk space usage
           to: sysadmin
#        warn: 0
#        crit: 0
 
        alarm: disk_space_usage
           on: disk_space._mnt_data_md6
         calc: $used * 100 / ($avail + $used)
        units: %
        every: 1m
         warn: $this > (($status >= $WARNING ) ? (99) : (99))
         crit: $this > (($status == $CRITICAL) ? (100) : (100))
        delay: up 1m down 15m multiplier 1.5 max 1h
         info: current disk space usage
           to: sysadmin
#        warn: 0
#        crit: 0
 

      '';
      
    };
  };

  # apcupsd
  services.apcupsd = {
    enable = true;
    configText = ''
      UPSCABLE usb
      UPSTYPE usb
      NISIP 0.0.0.0
    '';
  };

  # Btrfs Scrubbing
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
  };

  # Samba

  services.samba = {
    enable = true;
    enableNmbd = true;
    enableWinbindd = true;
    nsswins = true;
    securityType = "user";
    openFirewall = true;
#    extraConfig = ''
#      workgroup = WORKGROUP
#      server string = smbnix
#      netbios name = smbnix
#      security = user 
#      #use sendfile = yes
#      #max protocol = smb2
#      # note: localhost is the ipv6 localhost ::1
#      hosts allow = 192.168.0. 127.0.0.1 localhost
#      hosts deny = 0.0.0.0/0
#      guest account = nobody
#      map to guest = bad user
#    '';
    shares = {
      Files = {
        comment = "Files on NAS";
        path = "/media/Files";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
      };
      MiscFiles = {
        comment = "Random Files";
        path = "/media/MiscFiles";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
      };
      Films = {
        comment = "reeee";
        path = "/media/Files/Multimedia/Videos/Movies";
        browseable = "yes";
        "read only" = "yes";
        "guest ok" = "yes";
      };
      TV = {
        comment = "reeee";
        path = "/media/Files/Multimedia/Videos/TV";
        browseable = "yes";
        "read only" = "yes";
        "guest ok" = "yes";
      };
      Music = {
        comment = "reeee";
        path = "/media/Files/Multimedia/Music/Music";
        browseable = "yes";
        "read only" = "yes";
        "guest ok" = "yes";
      };
    };
  };
  
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  # XDG stuff 
  xdg = {
    portal.enable = true;
    portal.extraPortals = [ pkgs.xdg-desktop-portal-xapp pkgs.xdg-desktop-portal-gtk ];
    terminal-exec.enable = true;
  };

  # Security:

  security.polkit = {
    enable = true;
    extraConfig =  ''
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
  
  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
  
  nix.settings.experimental-features = [ "nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

}

