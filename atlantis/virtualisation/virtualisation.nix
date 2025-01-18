
{ config, lib, pkgs, ... }:

{

  imports = [
    ./incus.nix
  ];
  # Virtulisation:

  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = true;
  virtualisation.docker.package = pkgs.docker_27;
  virtualisation.docker.autoPrune.enable = true;
#  virtualisation.docker.listenOptions = [ "/run/docker.sock" "10.10.10.2:2375"];
  virtualisation.docker.listenOptions = [ "/run/docker.sock" ];
#  virtualisation.docker.enableNvidia = true;
#  virtualisation.containers.cdi.dynamic.nvidia.enable = true;
  virtualisation.docker.daemon.settings = {
    metrics-addr = "0.0.0.0:9323";
    log-driver = "json-file";
    log-opts = {
      max-file = "3";
      max-size = "10m";
    };
    features = {
      cdi = true;
    };
#    runtimes = {
#      nvidia = {
#        args = [];
#        path = "nvidia-container-runtime";
#      };
#    };
  }; 
}
