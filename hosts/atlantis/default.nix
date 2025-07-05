{ config, lib, pkgs, ... }:

{
  imports = [
    ../common/default.nix
    ./hardware-configuration.nix
    ./guisession.nix
    ./samba.nix
  ]

# Bootloader & Kernel stuff:
# 
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set kernel stuff
  boot.kernelPackages = pkgs.linuxPackages_xanmod;
  boot.kernelModules = ["nct6775"];

  # SystemD stuff
  boot.initrd.systemd.extraConfig = "DefaultLimitNOFILE=4096:524288";

# Secrets:
# 
  sops.defaultSopsFile = ../secrets/atlantis.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.secrets.wg_privkey_atlantis = {};
  sops.secrets.beszel_key_atlantis = {};
  sops.secrets.nut_admin_password = {};
  sops.secrets.nut_observer_password = {};


# Hardware:
# 
  ## nvidia stuff
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia.open = true;
  hardware.nvidia-container-toolkit.enable = true;
  hardware.graphics.enable = true;

  # ups stuff
  power.ups = {
    enable = true;
    mode = "netserver";
    openFirewall = true;
    users = {
      "admin" = {
        passwordFile = config.sops.secrets.nut_admin_password.path;
        actions = ["set" "fsd"];
        instcmds = [ "all" ];
        upsmon = "primary";
      };
      "observer" = {
        passwordFile = config.sops.secrets.nut_observer_password.path;
        upsmon = "secondary";
      };
    };
    ups."serverups" = {
      driver = "usbhid-ups";
      port = "auto";
      description = "Server UPS";
    };
    upsmon.monitor."serverups".user = "observer";
    upsd.listen = [
      {
        address = "::";
      }
      {
        address = "0.0.0.0";
      }
    ];
  };

# Users and Groups:
#
  users.users.root.openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCmXutLfqemWt5DqhrgIp+8xqvjw1hNmQ3U8tDWDrc89LpvUx2wIwiekUgXTa3XrfYd/PjrJnhN1N9XPCb0Fer5dp4fzZY74SepnqV2aBiOopAWiVP3ZWT48SGvM5OX26YiDOpHkfOCBLPhrBPlqLSoblHnvedzsR5V0oO62dEfgVPmSTnZRZERvfNdidVVJMODYiFeco3aFeX425FloGsjIuSDPCIu/u+iJFdNjpDah+nEsHWOuIDuIG3uvPkYWusFbuctQ6lL5I3QIJC2i++h+OvGMszPm8EH8P9KH3t+AfobudHDb5WRthdfDtWaig63tyiQrAxFZVsqDvhp/VEU0ZVQBgs2a1KV3sCpFM3rZX9lTBykthFsJvKDTj7G0fiO7Z0O1a0ajvcoPbu/WRe9PsyK7wgnz5HGMWcNFdLnFkXL51Q08jBC7/GAXsfJsw0zai22G9E0BRHQPiEjBC4CpCHWoIfXc//ife14z62DpiKm8HaDy5ZVLDoTX4Z+Dok= alistair@midgard" ];
  users.users.alistair = {
    isNormalUser = true;
    createHome = true;
    extraGroups = [ "wheel" "docker" "incus-admin"]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    uid = 1000;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCmXutLfqemWt5DqhrgIp+8xqvjw1hNmQ3U8tDWDrc89LpvUx2wIwiekUgXTa3XrfYd/PjrJnhN1N9XPCb0Fer5dp4fzZY74SepnqV2aBiOopAWiVP3ZWT48SGvM5OX26YiDOpHkfOCBLPhrBPlqLSoblHnvedzsR5V0oO62dEfgVPmSTnZRZERvfNdidVVJMODYiFeco3aFeX425FloGsjIuSDPCIu/u+iJFdNjpDah+nEsHWOuIDuIG3uvPkYWusFbuctQ6lL5I3QIJC2i++h+OvGMszPm8EH8P9KH3t+AfobudHDb5WRthdfDtWaig63tyiQrAxFZVsqDvhp/VEU0ZVQBgs2a1KV3sCpFM3rZX9lTBykthFsJvKDTj7G0fiO7Z0O1a0ajvcoPbu/WRe9PsyK7wgnz5HGMWcNFdLnFkXL51Q08jBC7/GAXsfJsw0zai22G9E0BRHQPiEjBC4CpCHWoIfXc//ife14z62DpiKm8HaDy5ZVLDoTX4Z+Dok= alistair@midgard"
    ];
  };
  users.users.hass = {
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDrcQ7vpeANSs2xXEp16XM2ctW5ZmMPa+7vvZIhCfMj2RJ/vrrdHbJkgfnTsU45Z6t/+WClClWvfO0yWKSZUgvfo+g+1YixSUC3ZfHw6rv5U/uGP1Y/0/JBcyiapSKQTYIeqN/6Ic35ehRD/vDFjdJoC4fUfmdpbWMkHlu7ZArhDDzVKjT2r6CgnGwEYzM6dD0dxwAXLJwWxHdEDm/tBwbQNmjZVIPJw6QMTJQwabO4c5uvtAJ4V1BUT0qTLaoxHw/7l6v0AeegpFTiMLHkmFTh01b3wfGoMZmoSSJhhg0oXHkbQ9NcoatrtNtf9Xibjf5GQEpVj7CmfLP7mlmjgZJJtT1QpIoe/Bi7XFHnWi8O06cn6QWTPptMISghyDUbbwROYBCq+tAbWmW7j7g/cXyrBzlCv/lSX1F1WdSf72g/12MwlPPRhV9KCf2bJX4c/9uS6SQJx2LB+hS9C5eFTLyvsSnND84HLbEnxRd0OSPctNFcltkk6aJ6KOXbGSqJgOM= root@atlantis" ];
    isNormalUser = true;
  };
  users.users.netdata = {
    extraGroups = ["docker" ];
  };

# System Services:
# for samba config, see samba.nix
  options.custom.atlantis.samba.enable = true;
  
# Other things:
# 
  system.stateVersion = "24.05"; # Did you read the comment?
}

