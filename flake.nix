{
  description = "My nixos systems in a flake!";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";

    # use the following for unstable:
    # nixpkgs.url = "nixpkgs/nixos-unstable";

    # or any branch you want:
    # nixpkgs.url = "nixpkgs/{BRANCH-NAME}";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Add deploy-rs as Flake input from GitHub
    deploy-rs.url = "github:serokell/deploy-rs";
    
    sops-nix.url = "github:Mic92/sops-nix";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.2-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    }; 

    nixvirt = {
      url = "https://flakehub.com/f/AshleyYakeley/NixVirt/0.5.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, deploy-rs, sops-nix, lix-module, nixvirt, ... }:
    let
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        atlantis = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./modules/default.nix
            ./hosts/atlantis/configuration.nix
            ./modules
            sops-nix.nixosModules.sops
            lix-module.nixosModules.default
            nixvirt.nixosModules.default
          ];
        };
        borealis = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./modules/default.nix
            ./hosts/borealis/configuration.nix
            lix-module.nixosModules.default
            sops-nix.nixosModules.sops
          ];
        };
        celestis = lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./modules/default.nix
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
            #nixos-hardware.nixosModules.raspberry-pi-3
            ./modules/raspberry-pi/3/default.nix
            ./hosts/celestis/configuration.nix
#            lix-module.nixosModules.default
            sops-nix.nixosModules.sops
          ];
        };
        morpheus = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./modules/default.nix
            ./hosts/morpheus/configuration.nix
            lix-module.nixosModules.default
            sops-nix.nixosModules.sops
          ];
        };
      };

      deploy.nodes = {
        celestis = {
          hostname = "celestis.dropbear-monster.ts.net";
          profiles.system = {
            sshUser = "alistair";
            sshOpts = [ "-t" ];
            magicRollback = false;
            path = deploy-rs.lib.aarch64-linux.activate.nixos
                     self.nixosConfigurations.celestis;
            user = "root";
          };
        };
      };
    };
  
}
