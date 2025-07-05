{ onfig, lib, pkgs, ...}:{
#
# Base packages for the system to always have installed.
# only add things here if the system is unusable/painful without them.
#

  # enable zsh in the system.
  programs.zsh.enable = true;
  
  environment.systemPackages = with pkgs; [
    util-linuxMinimal
    coreutils
    curl
    findutils
    gnused
    pstree
    lsusb
    traceroute
    ping
    lsof
    bc
    zip
    unzip
    watch
    telnet
    whois
    dig
    nslookup
    btrfs-progs
    mergerfs
    mergerfs-tools
    python3Full
    ffmpeg-full
    vim
    curl
    htop
    nvtopPackages.full
    fastfecth
    git
    zsh
    nix-index
    pciutils
    wakeonlan
    smartmontools
    lm_sensors
    lshw
    wireguard-tools
    smartmontools
    mc
    jq
    nmap
    ripgrep
  ];
}
