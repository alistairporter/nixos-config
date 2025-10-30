{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.custom.gnome-boxes;
in {
  options.custom.gnome-boxes = {
    enable = mkEnableOption "installs gnome boxes package and enables supporting components including libvirt";

    vm-priv-accounts = mkOption {
      type = types.listOf types.str;
      default = [ "" ];
      example = [ "alice" ];
      description = "users to be added to vm management groups";
    };
  };

  config = mkIf cfg.enable {
    # Set up virtualisation
    virtualisation.libvirtd = {
      enable = true;

      # Enable TPM emulation (for Windows 11)
      qemu = {
        swtpm.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };

    # Enable USB redirection
    virtualisation.spiceUSBRedirection.enable = true;
    

    # Allow VM management
    users.groups.libvirtd.members = cfg.vm-priv-accounts;
    users.groups.kvm.members = cfg.vm-priv-accounts;

    # Enable VM networking and file sharing
    environment.systemPackages = with pkgs; [
        # ... your other packages ...
        gnome-boxes # VM management
        dnsmasq # VM networking
        phodav # (optional) Share files with guest VMs
    ];
  };
}
