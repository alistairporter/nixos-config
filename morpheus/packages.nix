{ config, lib, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    docker-compose
    tmux
    git
    vim
    wget
    htop
    neofetch
    zsh
    atuin
    starship
    iptables
    gnupg
    pinentry
    wakeonlan
    pinentry-curses
    prometheus-node-exporter
  ];

  programs = {
    dconf.enable = true;
    zsh.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
