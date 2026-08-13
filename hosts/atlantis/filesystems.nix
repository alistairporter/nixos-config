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
  # use swapfile for swap
  swapDevices = [{device = "/swap/swapfile";}];

  # Filesystems:
  fileSystems = {
    # mount root subvolume
    "/" = {
      device = "/dev/disk/by-uuid/3413f16e-7b6b-4899-92ad-379cc3cd5e68";
      fsType = "btrfs";
      options = [
        "subvol=root"
        "compress=zstd"
      ];
    };
    # mount efi partition as boot
    "/boot" = {
      device = "/dev/disk/by-uuid/4917-BEC8";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
    # keep user data on seperate subvolume
    "/home" = {
      device = "/dev/disk/by-uuid/3413f16e-7b6b-4899-92ad-379cc3cd5e68";
      fsType = "btrfs";
      options = [
        "subvol=home"
        "compress=zstd"
      ];
    };
    # keep nix store on seperate subvolume
    "/nix" = {
      device = "/dev/disk/by-uuid/3413f16e-7b6b-4899-92ad-379cc3cd5e68";
      fsType = "btrfs";
      options = [
        "subvol=nix"
        "compress=zstd"
        "noatime"
      ];
    };
    # special subvolume for swapfile to keep out of snapshots
    "/swap" = {
      device = "/dev/disk/by-uuid/3413f16e-7b6b-4899-92ad-379cc3cd5e68";
      fsType = "btrfs";
      options = [
        "subvol=swap"
        "noatime"
      ];
    };

    # mount appdata subvolume in place of old ssd, keeping traditional location
    "/media/MiscFiles" = {
      device = "/dev/disk/by-uuid/3413f16e-7b6b-4899-92ad-379cc3cd5e68";
      fsType = "btrfs";
      options = [
        "subvol=MiscFiles"
        "compress=zstd"
        "nosuid"
        "nodev"
        "nofail"
        "x-gvfs-show"
      ];
    };
  };
}
