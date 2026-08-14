{pkgs, ...}: {
  # incus needs nftables on nixos
  networking.nftables.enable = true;

  virtualisation.incus = {
    enable = true;
    ui.enable = true;
    preseed = {
      networks = [
        {
          name = "incusbr0";
          type = "bridge";
          config = {
            "ipv4.address" = "10.0.100.1/24";
            "ipv4.nat" = "true";
          };
        }
      ];
      storage_pools = [
        {
          name = "default";
          driver = "btrfs";
          config.source = "/var/lib/incus/storage-pools/default";
        }
      ];
      profiles = [
        {
          name = "default";
          config = {
            "security.privileged" = "true";
          };
          devices = {
            eth0 = {
              name = "eth0";
              network = "incusbr0";
              type = "nic";
            };
            root = {
              path = "/";
              pool = "default";
              type = "disk";
            };
          };
        }
      ];
    };
  };
  # Also enable libvirtd for virt-manager
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
    };
  };

  environment.systemPackages = with pkgs; [
    # Virtualization packages
    qemu_kvm         # QEMU with KVM support
    virt-manager     # GUI for VM management
    libvirt          # libvirt client tools
    bridge-utils     # Network bridge utilities
  ];
  # https://github.com/NixOS/nixpkgs/issues/263359
  networking.firewall.trustedInterfaces = ["incusbr0"];
}
