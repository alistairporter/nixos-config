{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    ../common/global
    ../common/users/alistair

    ../common/optional/systemd-boot.nixi
    ../common/optional/docker.nix
    ../common/optional/incus.nix
  ];

  networking = {
    hostName = "borealis";
    useDHCP = true;
  };

  networking.useNetworkd = true;

  networking.nftables.enable = true;

  systemd.network.enable = true;

  systemd.network.networks."10-wan" = {
    matchConfig.Name = "enp0s31f6";
    networkConfig = {
      # start a DHCP Client for IPv4 Addressing/Routing
      DHCP = "ipv4";
      # accept Router Advertisements for Stateless IPv6 Autoconfiguraton (SLAAC)
      IPv6AcceptRA = true;
    };
    # make routing on this interface a dependency for network-online.target
    linkConfig.RequiredForOnline = "routable";
  };

  networking.wireguard = {
    enable = true;
    interfaces = {
      "wgtunnelinfra" = {
#        privateKey = "SECRET_REDACTED";
        privateKeyFile = config.sops.secrets.wg_privkey_borealis.path;
        ips = ["10.10.10.3/32"];
        peers = [
          {
            name = "atlantis";
            endpoint = "aporter.xyz:51821";
            publicKey = "eYrWhvMGJc8BFadkwOhVQUQf/3OFOLiybYvE/JK7gXM=";
            allowedIPs = ["10.10.10.0/24"];
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };
  sops.secrets.wg_privkey_borealis = {
    sopsFile = ./secrets.yaml;
  };

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod;
    binfmt.emulatedSystems = [
      "aarch64-linux"
      "i686-linux"
    ];
  };

  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
    "/swap".options = [ "noatime" ];
  };

  # Beszel Agent:
  #
  services.beszel.agent = {
    enable = true;
    environmentFile = "${config.sops.secrets.beszel_key_borealis.path}";
  };
  sops.secrets.beszel_key_borealis = {
    sopsFile = ./secrets.yaml;
  };

  hardware.graphics.enable = true;

  system.stateVersion = "24.05";
}
