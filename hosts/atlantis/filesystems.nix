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

     
    ## data disk mounts
    "/mnt/disks/md1" = {
      device = "/dev/disk/by-uuid/2fd36c76-3626-42ce-befe-248c7a3f2f7c";
      options = [
        "defaults"
        "nofail"
        "autodefrag"
        "compress=zstd"
        "subvol=data"
      ];
    };
    "/mnt/snapraidContent/md1" = {
      device = "/dev/disk/by-uuid/2fd36c76-3626-42ce-befe-248c7a3f2f7c";
      options = [
        "defaults"
        "nofail"
        "autodefrag"
        "compress=zstd"
        "subvol=snapraidContent"
      ];
    };
    
    "/mnt/disks/md2" = {
      device = "/dev/disk/by-uuid/83ac0fbd-2869-4958-b5f4-08a71e132545";
      options = [
        "defaults"
        "nofail"
        "autodefrag"
        "compress=zstd"
        "subvol=data"
      ];
    };
    "/mnt/snapraidContent/md2" = {
      device = "/dev/disk/by-uuid/83ac0fbd-2869-4958-b5f4-08a71e132545";
      options = [
        "defaults"
        "nofail"
        "autodefrag"
        "compress=zstd"
        "subvol=snapraidContent"
      ];
    };

    "/mnt/disks/md3" = {
      device = "/dev/disk/by-uuid/0013e2f5-f54e-4074-9e0e-ecca9acefb3a";
      options = [
        "defaults"
        "nofail"
        "autodefrag"
        "compress=zstd"
        "subvol=data"
      ];
    };
    "/mnt/snapraidContent/md3" = {
      device = "/dev/disk/by-uuid/0013e2f5-f54e-4074-9e0e-ecca9acefb3a";
      options = [
        "defaults"
        "nofail"
        "autodefrag"
        "compress=zstd"
        "subvol=snapraidContent"
      ];
    };

    "/mnt/disks/md4" = {
      device = "/dev/disk/by-uuid/910e0fe0-4be2-47a0-98ef-fee0e445105d";
      options = [
        "defaults"
        "nofail"
        "autodefrag"
        "compress=zstd"
        "subvol=data"
      ];
    };
    "/mnt/snapraidContent/md4" = {
      device = "/dev/disk/by-uuid/910e0fe0-4be2-47a0-98ef-fee0e445105d";
      options = [
        "defaults"
        "nofail"
        "autodefrag"
        "compress=zstd"
        "subvol=snapraidContent"
      ];
    };

    "/mnt/disks/md5" = {
      device = "/dev/disk/by-uuid/e38ac870-e56f-425b-8b13-fdbd5af2a53a";
      options = [
        "defaults"
        "nofail"
        "autodefrag"
        "compress=zstd"
        "subvol=data"
      ];
    };
    "/mnt/snapraidContent/md5" = {
      device = "/dev/disk/by-uuid/e38ac870-e56f-425b-8b13-fdbd5af2a53a";
      options = [
        "defaults"
        "nofail"
        "autodefrag"
        "compress=zstd"
        "subvol=snapraidContent"
      ];
    };
    
    "/mnt/disks/md6" = {
      device = "/dev/disk/by-uuid/e1fb50b0-7b71-4490-a752-69af36d44c7c";
      options = [
        "defaults"
        "nofail"
        "autodefrag"
        "compress=zstd"
        "subvol=data"
      ];
    };
    "/mnt/snapraidContent/md6" = {
      device = "/dev/disk/by-uuid/e1fb50b0-7b71-4490-a752-69af36d44c7c";
      options = [
        "defaults"
        "nofail"
        "autodefrag"
        "compress=zstd"
        "subvol=snapraidContent"
      ];
    };
  };
}
