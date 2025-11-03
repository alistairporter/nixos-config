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

  # Snapraid
  services.snapraid = {
    enable = true;
    parityFiles = [
      "/mnt/disks/pd1/snapraid.parity"
    ];
    contentFiles = [
      "/var/snapraid.content"
      "/mnt/snapraidContent/md1/snapraid.content"
      "/mnt/snapraidContent/md2/snapraid.content"
      # "/mnt/snapraidContent/md3/snapraid.content"
      "/mnt/snapraidContent/md4/snapraid.content"
      "/mnt/snapraidContent/md5/snapraid.content"
      "/mnt/snapraidContent/md6/snapraid.content"
    ];
    dataDisks = {
      d1 = "/mnt/disks/md1";
      d2 = "/mnt/disks/md2";
      # d3 = "/mnt/disks/md3";
      d4 = "/mnt/disks/md4";
      d5 = "/mnt/disks/md5";
      d6 = "/mnt/disks/md6";
    };
    exclude = [
      "*.unrecoverable"
      "/tmp/"
      "/lost+found/"
      "downloads/"
      "appdata/"
      "*.!sync"
      "/.snapshots/"
    ];
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
        "minfreespace=100G"
        "fsname=mergerfsMediaFiles"
        "x-gvfs-show"
      ];
    };

    ## snapraid parity mounts
    "/mnt/disks/pd1" = {
      device = "/dev/disk/by-uuid/c812a19a-3805-4351-ba83-9d0d90520bed";
      options = [
        "defaults"
        "autodefrag"
      ];
    };

    ## btrfs commands
    ### mkfs.btrfs /dev/disk/blah
    ### btrfs subvolume create /mnt/disks/diskX/data
    ### btrfs subvolume create /mnt/snapct/diskX/snapraidContent
    ## data disk mounts
    "/mnt/disks/md1" = {
      device = "/dev/disk/by-uuid/2fd36c76-3626-42ce-befe-248c7a3f2f7c";
      options = [
        "defaults"
        "autodefrag"
        "compress=zstd"
        "subvol=data"
      ];
    };
    "/mnt/snapraidContent/md1" = {
      device = "/dev/disk/by-uuid/2fd36c76-3626-42ce-befe-248c7a3f2f7c";
      options = [
        "defaults"
        "autodefrag"
        "compress=zstd"
        "subvol=snapraidContent"
      ];
    };

    "/mnt/disks/md2" = {
      device = "/dev/disk/by-uuid/11445e2a-cfd0-4b0e-be89-b7fcc4367349";
      options = [
        "defaults"
        "autodefrag"
        "compress=zstd"
        "subvol=data"
      ];
    };
    "/mnt/snapraidContent/md2" = {
      device = "/dev/disk/by-uuid/11445e2a-cfd0-4b0e-be89-b7fcc4367349";
      options = [
        "defaults"
        "autodefrag"
        "compress=zstd"
        "subvol=snapraidContent"
      ];
    };

    "/mnt/disks/md4" = {
      device = "/dev/disk/by-uuid/14b2089d-b806-4b2e-939a-5ec03e560378";
      options = [
        "defaults"
        "autodefrag"
        "compress=zstd"
        "subvol=data"
      ];
    };
    "/mnt/snapraidContent/md4" = {
      device = "/dev/disk/by-uuid/14b2089d-b806-4b2e-939a-5ec03e560378";
      options = [
        "defaults"
        "autodefrag"
        "compress=zstd"
        "subvol=snapraidContent"
      ];
    };

    "/mnt/disks/md5" = {
      device = "/dev/disk/by-uuid/e38ac870-e56f-425b-8b13-fdbd5af2a53a";
      options = [
        "defaults"
        "autodefrag"
        "compress=zstd"
        "subvol=data"
      ];
    };
    "/mnt/snapraidContent/md5" = {
      device = "/dev/disk/by-uuid/e38ac870-e56f-425b-8b13-fdbd5af2a53a";
      options = [
        "defaults"
        "autodefrag"
        "compress=zstd"
        "subvol=snapraidContent"
      ];
    };

    "/mnt/disks/md6" = {
      device = "/dev/disk/by-uuid/8b2336d6-90b1-43c5-b696-3f1784780e42";
      options = [
        "defaults"
        "autodefrag"
        "compress=zstd"
        "subvol=data"
      ];
    };
    "/mnt/snapraidContent/md6" = {
      device = "/dev/disk/by-uuid/8b2336d6-90b1-43c5-b696-3f1784780e42";
      options = [
        "defaults"
        "autodefrag"
        "compress=zstd"
        "subvol=snapraidContent"
      ];
    };
  };
}
