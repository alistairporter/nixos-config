{
  config,
  lib,
  pkgs,
  ...
}: {
  systemd.services.netdata.serviceConfig.CapabilityBoundingSet = ["CAP_SETGID" "CAP_DAC_OVERRIDE" "CAP_DAC_READ_SEARCH" "CAP_FOWNER" "CAP_SYS_RAWIO" "CAP_SETPCAP" "CAP_SYS_ADMIN" "CAP_PERFMON" "CAP_SYS_PTRACE" "CAP_SYS_RESOURCE" "CAP_NET_RAW" "CAP_SYS_CHROOT" "CAP_NET_ADMIN" "CAP_SETGID" "CAP_SETUID" "CAP_CHOWN"];
  systemd.services.netdata.path = [pkgs.jq];
  services = {
    netdata = {
      enable = true;
      config = {
        global = {"memory mode" = "none";};
        plugins = {
          "ebpf" = "yes";
        };
        web = {
          mode = "none";
          "accept a streaming request every seconds" = 0;
        };
      };
      configDir = {
        "stream.conf" = pkgs.writeText "stream.conf" ''
          [stream]
            enabled = yes
            destination = 10.10.10.2:19999
            api key = 3d560d1c-edee-4557-8f2f-e31d1335aa5b
        '';
        "go.d/docker.conf" = pkgs.writeText "go.d/docker.conf" ''
          jobs:
            - name: local
              address: 'unix:///var/run/docker.sock'
              timeout: 2
              collect_container_size: yes
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
      };
    };
  };
}
