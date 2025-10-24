{ config, pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./monitoring/monitoring.nix
    ./networking.nix
    ./packages.nix
    ./services/services.nix
    ./usersandgroups.nix
    ./virtualisation.nix
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  #Secrets
  sops.defaultSopsFile = ../../secrets/morpheus.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.secrets.wg_privkey_morpheus_infra = {};
  sops.secrets.wg_privkey_morpheus_vpn = {};
  sops.secrets.microsocks_password_morpheus = {};
  sops.secrets.beszel_key_morpheus = {};
  
  time.timeZone = "Europe/London";

  system = {
    stateVersion = "23.11";
    autoUpgrade = {
      enable = true;
      allowReboot = true;
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes"];
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "03:45" ];

  lix.enable = true;
}  
