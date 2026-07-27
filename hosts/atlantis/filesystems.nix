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

    ## data disk mount

    "/mnt/tank" = {
      device = "tank";
      fsType = "zfs";
    };
   
    "/mnt/tank/files" = {
      device = "tank/files";
      fsType = "zfs";
    };

    "/media/Files" = {
      device = "tank/files";
      fsType = "zfs";
    };
  };
}
