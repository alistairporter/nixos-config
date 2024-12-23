{ config, lib, pkgs, modulesPath, ... }:

{


  # Btrfs Scrubbing
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
  };


  # Filesystems:
  fileSystems = {
  # add options to fs definitions in hardware-configuration.nix
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
    "/swap".options = [ "noatime" ];
    

    "/mnt/data/md4" = {
      device = "/dev/disk/by-uuid/14b2089d-b806-4b2e-939a-5ec03e560378";
      options = [
        "defaults"
        "autodefrag"
        "compress=zstd"
      ];
    };
    "/mnt/data/md5" = {
      device = "/dev/disk/by-uuid/e38ac870-e56f-425b-8b13-fdbd5af2a53a";
      options = [
        "defaults"
        "autodefrag"
        "compress=zstd"
      ];
    };
    "/mnt/data/md6" = {
      device = "/dev/disk/by-uuid/8b2336d6-90b1-43c5-b696-3f1784780e42";
      options = [
        "defaults"
        "autodefrag"
        "compress=zstd"
      ];
    };

    "/media/MiscFiles" = {
      device = "/dev/disk/by-uuid/3d4a90c0-9bf1-449b-b855-4b04f5e66e30";
      options = [
        "nosuid"
        "nodev"
        "nofail"
        "x-gvfs-show"
      ];
    };

    "/media/Files" = {
      fsType = "fuse.mergerfs";
      device = "/mnt/data/\*";
      options = [
        "allow_other"
        "direct_io"
        "use_ino"
        "category.create=lfs"
        "moveonenospc=true"
        "minfreespace=100G"
        "fsname=mergerfsMediaFiles"
        "x-gvfs-show"
      ];
    };
  };
}
