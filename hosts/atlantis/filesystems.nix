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
    "/media/Files" = {
      device = "/dev/disk/by-uuid/bcf5ad28-9515-43a2-b560-8e2357641089";
      fsType = "btrfs";
      options = [
        "defaults"
        "nofail"
        "autodefrag"
        "compress=zstd"
        "subvol=data"
      ];
    };
  };
}
