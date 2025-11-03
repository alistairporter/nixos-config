{config, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./services

    ../common/global
    ../common/users/alistair

    ../common/optional/tailscale-exit-node.nix
  ];

  networking = {
    hostName = "morpheus";
    useDHCP = true;
  };

  virtualisation.vmware.guest = {
    enable = true;
    headless = true;
  };

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  # Beszel Agent:
  #
  services.beszel.agent = {
    enable = true;
    environmentFile = "${config.sops.secrets.beszel_key_morpheus.path}";
  };
  sops.secrets.beszel_key_morpheus = {
    owner = "beszel-agent";
    group = "beszel-agent";
    mode = "0440";
    sopsFile = ./secrets.yaml;
  };

  lix.enable = true;

  system.stateVersion = "22.11";
}
