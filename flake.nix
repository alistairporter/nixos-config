{
  description = "My nixos systems in a flake!";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";

    # use the following for unstable:
    # nixpkgs.url = "nixpkgs/nixos-unstable";

    # or any branch you want:
    # nixpkgs.url = "nixpkgs/{BRANCH-NAME}";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    sops-nix.url = "github:Mic92/sops-nix";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    }; 

    nixvirt = {
      url = "https://flakehub.com/f/AshleyYakeley/NixVirt/0.5.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, sops-nix, lix-module, nixvirt, ... }:
    let
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        celestis = lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            nixos-hardware.nixosModules.raspberry-pi-3
            ./celestis/configuration.nix
#            lix-module.nixosModules.default
            sops-nix.nixosModules.sops
          ];
        };
        borealis = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./borealis/configuration.nix
            lix-module.nixosModules.default
            sops-nix.nixosModules.sops
          ];
        };
        atlantis = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./atlantis/configuration.nix
            sops-nix.nixosModules.sops
            lix-module.nixosModules.default
            nixvirt.nixosModules.default
          ];
        };
        morpheus = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./morpheus/configuration.nix
            lix-module.nixosModules.default
            sops-nix.nixosModules.sops
          ];
        };
      };
    };
  
}
