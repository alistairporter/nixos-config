{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  # Btrfs Scrubbing
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
  };

  # ZFS Scrubbing
  services.zfs.autoScrub = {
    enable = true;
    interval = "weekly";
    pools = ["tank"];
  };

  # Don't prompt for ZFS encryption credentials at boot; encrypted datasets are
  # unlocked post-boot by the systemd unit(s) below once sops-nix has written
  # the key material to /run/secrets.
  boot.zfs.requestEncryptionCredentials = false;

  sops.secrets.zfs_key_tank_private = {
    sopsFile = ./secrets.yaml;
  };

  systemd.services.zfs-load-key-tank-private = {
    description = "Load ZFS encryption key for tank/private and mount it";
    wantedBy = [ "multi-user.target" ];
    after = [ "zfs-import-tank.service" ];
    requires = [ "zfs-import-tank.service" ];
    unitConfig.ConditionPathExists = config.sops.secrets.zfs_key_tank_private.path;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      if ! ${pkgs.zfs}/bin/zfs get -H -o value keystatus tank/private | grep -qx available; then
        ${pkgs.zfs}/bin/zfs load-key -L file://${config.sops.secrets.zfs_key_tank_private.path} tank/private
      fi
      ${pkgs.zfs}/bin/zfs mount tank/private || true
    '';
  };

  # Import zfs pool on boot
  boot.zfs.extraPools = [ "tank" ];

  # Filesystems:
  fileSystems = {
    # add options to fs definitions in hardware-configuration.nix
    "/".options = ["compress=zstd"];
    "/home".options = ["compress=zstd"];
    "/nix".options = ["compress=zstd" "noatime"];
    "/swap".options = ["noatime"];

    ## appdata ssd mount
    "/media/MiscFiles" = {
      device = "/dev/disk/by-uuid/3d4a90c0-9bf1-449b-b855-4b04f5e66e30";
      fsType = "btrfs";
      options = [
        "nosuid"
        "nodev"
        "nofail"
        "x-gvfs-show"
      ];
    };
  };
}
