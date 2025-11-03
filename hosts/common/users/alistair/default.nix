{
  pkgs,
  config,
  lib,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.mutableUsers = false;
  users.users.alistair = {
    description = "Alistair Porter";
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ifTheyExist [
      "audio"
      "deluge"
      "docker"
      "git"
      "i2c"
      "incus"
      "kvm"
      "libvirtd"
      "lxd"
      "minecraft"
      "mysql"
      "network"
      "plugdev"
      "podman"
      "tss"
      "video"
      "wheel"
      "wireshark"
    ];

    openssh.authorizedKeys.keys = lib.splitString "\n" (builtins.readFile ../../../../home/alistair/ssh.pub);
    hashedPasswordFile = config.sops.secrets.alistair-password.path;
    packages = [pkgs.home-manager];
  };

  sops.secrets.alistair-password = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };

  home-manager.users.alistair = import ../../../../home/alistair/${config.networking.hostName}.nix;

  security.pam.services = {
    swaylock = {};
    hyprlock = {};
  };
}
