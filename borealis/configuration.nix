# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./virtualisation.nix
      ./monitoring/monitoring.nix
      ./services/services.nix
    ];

  sops.defaultSopsFile = ../secrets/borealis.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.secrets.wg_privkey_borealis = {};

#  sops.secrets.wgprivborealis = 

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
    "/swap".options = [ "noatime" ];
  };

  networking.hostName = "borealis"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
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

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alistair = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    hashedPassword = "SECRET_REDACTED";
  #   packages = with pkgs; [
  #     firefox
  #     tree
  #   ];
  };
  users.users.hass = {
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDrcQ7vpeANSs2xXEp16XM2ctW5ZmMPa+7vvZIhCfMj2RJ/vrrdHbJkgfnTsU45Z6t/+WClClWvfO0yWKSZUgvfo+g+1YixSUC3ZfHw6rv5U/uGP1Y/0/JBcyiapSKQTYIeqN/6Ic35ehRD/vDFjdJoC4fUfmdpbWMkHlu7ZArhDDzVKjT2r6CgnGwEYzM6dD0dxwAXLJwWxHdEDm/tBwbQNmjZVIPJw6QMTJQwabO4c5uvtAJ4V1BUT0qTLaoxHw/7l6v0AeegpFTiMLHkmFTh01b3wfGoMZmoSSJhhg0oXHkbQ9NcoatrtNtf9Xibjf5GQEpVj7CmfLP7mlmjgZJJtT1QpIoe/Bi7XFHnWi8O06cn6QWTPptMISghyDUbbwROYBCq+tAbWmW7j7g/cXyrBzlCv/lSX1F1WdSf72g/12MwlPPRhV9KCf2bJX4c/9uS6SQJx2LB+hS9C5eFTLyvsSnND84HLbEnxRd0OSPctNFcltkk6aJ6KOXbGSqJgOM= root@atlantis" ];
    isNormalUser = true;
  };
  # disable root account
  users.users.root.hashedPassword = "!";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nano # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    tmux
    usbutils
    pciutils
    sops
    wakeonlan
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.zsh.enable = true;
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

}

