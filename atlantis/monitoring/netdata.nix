{ config, lib, pkgs, ... }:

{

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
}
