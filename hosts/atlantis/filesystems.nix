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
      options = [
        "nosuid"
        "nodev"
        "nofail"
        "x-gvfs-show"
      ];
    };

    ## mergerfs mount
    "/media/Files" = {
      fsType = "fuse.mergerfs";
      device = "/mnt/disks/md*";
      options = [
        "allow_other"
        "direct_io"
        "use_ino"
        "category.create=lfs"
        "moveonenospc=true"
        "minfreespace=500GB"
        "fsname=mergerfsMediaFiles"
        "x-gvfs-show"
      ];
    };

     
    # ## data disk mounts
    "/mnt/disks/mdnew" = {
      device = "/dev/disk/by-uuid/bcf5ad28-9515-43a2-b560-8e2357641089";
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
