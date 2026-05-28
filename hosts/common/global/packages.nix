{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    atuin
    btrfs-progs
    fastfetch
    ffmpeg-full
    git
    gnupg
    helix
    htop
    iptables
    lm_sensors
    nano
    pciutils
    # See https://github.com/NixOS/nixpkgs/issues/522307
    (pipx.overridePythonAttrs (old: {
      disabledTests =
        (old.disabledTests or [])
        ++ [
          "test_fix_package_name"
          "test_parse_specifier_for_metadata"
        ];
    }))
    progress
    python3
    smartmontools
    sops
    starship
    tmux
    usbutils
    util-linuxMinimal
    uv
    wakeonlan
    wget
    xdg-utils
    zsh
  ];
}
