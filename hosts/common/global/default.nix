# This file (and the global directory) holds config that i use on all hosts
{
  inputs,
  outputs,
  lib,
  private,
  pkgs,
  ...
}: {
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
      ./appimage.nix
      ./fwupd.nix
      ./gamemode.nix
      ./kdeconnect.nix
      ./locale.nix
      ./nix-ld.nix
      ./nix.nix
      ./openssh.nix
      ./optin-persistence.nix
      ./packages.nix
      ./podman.nix
      ./prometheus-node-exporter.nix
      ./sops.nix
      ./steam-hardware.nix
      ./swappiness.nix
      ./systemd-initrd.nix
      ./tailscale.nix
      ./tpm.nix
      ./upower.nix
      ./zsh.nix
    ]
    ++ (builtins.attrValues outputs.nixosModules);

  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "hm-backup";
  home-manager.extraSpecialArgs = {
    inherit inputs outputs private;
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      clementine.ipod = true; # enables compiletime ipod support in clementine
    };
  };

  hardware.enableRedistributableFirmware = true;
  networking.domain = private.domain;

  # Increase open file limit for sudoers
  security.pam.loginLimits = [
    {
      domain = "@wheel";
      item = "nofile";
      type = "soft";
      value = "524288";
    }
    {
      domain = "@wheel";
      item = "nofile";
      type = "hard";
      value = "1048576";
    }
  ];

  # enable esp32 flashing without sudo
  services.udev.packages = with pkgs; [ platformio-core.udev ];

  environment.persistence = lib.mkForce {};
}
