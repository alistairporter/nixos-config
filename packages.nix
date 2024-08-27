{ config, lib, pkgs, ... }:

{
 # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    util-linuxMinimal
    btrfs-progs
    mergerfs
    mergerfs-tools
    python3Full
    flatpak
    firefox
    calibre
    gnome.gnome-software
    gnome.gnome-disk-utility
    baobab
    vim
    wget
    htop
    nvtopPackages.full
    fastfetch
    git
    zsh
    nix-index
#    docker-compose
#    nvidia-container-toolkit
    pciutils
    wakeonlan
    smartmontools
  ];
}
