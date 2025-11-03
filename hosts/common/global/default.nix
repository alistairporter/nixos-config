# This file (and the global directory) holds config that i use on all hosts
{
  inputs,
  outputs,
  lib,
  ...
}: {
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
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
  home-manager.extraSpecialArgs = {
    inherit inputs outputs;
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  hardware.enableRedistributableFirmware = true;
  networking.domain = "aporter.xyz";

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

  environment.persistence = lib.mkForce {};
}
