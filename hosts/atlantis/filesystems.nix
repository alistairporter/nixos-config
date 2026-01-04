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
      "/mnt/disks/pd2/snapraid.parity"
    ];
    contentFiles = [
      "/var/snapraid.content"
      "/mnt/snapraidContent/md1/snapraid.content"
      "/mnt/snapraidContent/md2/snapraid.content"
      "/mnt/snapraidContent/md3/snapraid.content"
      "/mnt/snapraidContent/md4/snapraid.content"
      "/mnt/snapraidContent/md5/snapraid.content"
      "/mnt/snapraidContent/md6/snapraid.content"
    ];
    dataDisks = {
      d1 = "/mnt/disks/md1";
      d2 = "/mnt/disks/md2";
      d3 = "/mnt/disks/md3";
      d4 = "/mnt/disks/md4";
      d5 = "/mnt/disks/md5";
      d6 = "/mnt/disks/md6";
    };
    exclude = [
      "downloads/"
      "appdata/"
      "*.!sync"
      "/.snapshots/"
      ".trash/"
      "*.nfo"
      "poster.jpg"
      "*-poster.jpg"
      "banner.jpg"
      "*-banner.jpg"
      "fanart.jpg"
      "clearlogo.png"
      "*-thumb.jpg"
      "*.srt"
      "*.vtt"
      "trickplay/"
      "active/"
      "completed/"
      "watch/"
      ".transcode_cache/"
      "*.unrecoverable"
      "catcam/"
      "tmp/"
      "/lost+found/"
      ".AppleDouble"
      "._AppleDouble"
      ".DS_Store"
      ".Thumbs.db"
      ".fseventsd"
      ".Spotlight-V100"
      ".TemporaryItems"
      ".Trashes"
      ".AppleDB"
      "._*"
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
        "minfreespace=500GB"
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
        "nofail"
      ];
    };

    "/mnt/disks/pd2" = {
      device = "/dev/disk/by-uuid/8b2336d6-90b1-43c5-b696-3f1784780e42";
      options = [
        "defaults"
        "autodefrag"
        "nofail"
      ];
    };

    ### BTRFS commands for setting up new media disk:
    # format disk with btrfs:
    # $ sudo mkfs.btrfs /dev/disk/by-uuid/blah
    ## Then mount somewhere e.g under ~ or /media, where doesn't matter.
    # $ mount /dev/disk/by-uuid/blah /mnt/driveMountPoint
    # $ cd /mnt/driveMountPoint/
    ## Create subvolumes for data and snapraid:
    # $ btrfs subvolume create data
    # $ btrfs subvolume create snapraidContent
    # Finally add mount definition and snapraid confiuration(s), and rebuild the NixOS closure.

     
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
      device = "/dev/disk/by-uuid/14b2089d-b806-4b2e-939a-5ec03e560378";
      options = [
        "defaults"
        "nofail"
        "autodefrag"
        "compress=zstd"
        "subvol=data"
      ];
    };
    "/mnt/snapraidContent/md4" = {
      device = "/dev/disk/by-uuid/14b2089d-b806-4b2e-939a-5ec03e560378";
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
