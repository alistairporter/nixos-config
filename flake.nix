{
  description = "My nixos systems in a flake!";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";

    # use the following for unstable:
    # nixpkgs.url = "nixpkgs/nixos-unstable";

    # or any branch you want:
    # nixpkgs.url = "nixpkgs/{BRANCH-NAME}";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Add deploy-rs as Flake input from GitHub
    deploy-rs.url = "github:serokell/deploy-rs";

    # SOPS secret managment
    sops-nix.url = "github:Mic92/sops-nix";

    # Lix a fork of the nix package manager
    # Replaced with a module in ./modules/nixos/lix.nix
    # due to excessive build times on weaker systems
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.2-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    }; 

    # NixVirt
    nixvirt = {
      url = "https://flakehub.com/f/AshleyYakeley/NixVirt/0.5.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix Index Database
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    
    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # NixOS Secureboot
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Overlays
    
    nur.url = "github:nix-community/NUR";
    
    nixGL = {
      url = "github:nix-community/nixGL/310f8e49a149e4c9ea52f1adf70cdc768ec53f8a";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@ { self, nixpkgs, nixos-hardware, deploy-rs, sops-nix, lix-module, nixvirt, home-manager, lanzaboote, nix-index-database, nur, nixGL, ... }:
    let
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        atlantis = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./modules/nixos
            ./hosts/atlantis/configuration.nix
            # ./modules
            sops-nix.nixosModules.sops
            # lix-module.nixosModules.default
            nixvirt.nixosModules.default
          ];
        };
        borealis = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./modules/nixos
            ./hosts/borealis/configuration.nix
            # lix-module.nixosModules.default
            sops-nix.nixosModules.sops
          ];
        };
#         celestis = lib.nixosSystem {
#           system = "aarch64-linux";
#           modules = [
#             ./modules/default.nix
#             "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
#             #nixos-hardware.nixosModules.raspberry-pi-3
#             ./modules/raspberry-pi/3/default.nix
#             ./hosts/celestis/configuration.nix
# #            lix-module.nixosModules.default
#             sops-nix.nixosModules.sops
#           ];
#         };
        midgard = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./modules/nixos
            nixos-hardware.nixosModules.lenovo-thinkpad-t480
            nixos-hardware.nixosModules.common-gpu-intel-kaby-lake
            # lix-module.nixosModules.default
            lanzaboote.nixosModules.lanzaboote
            # sops-nix.nixosModules.sops
            ./hosts/midgard/configuration.nix
            ./hosts/midgard/hardware-configuration.nix
            ./hosts/midgard/gnome.nix
            ./hosts/midgard/lanzaboote.nix
          ];
        };
        morpheus = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./modules/nixos
            ./hosts/morpheus/configuration.nix
            # lix-module.nixosModules.default
            sops-nix.nixosModules.sops
          ];
        };
        olympus = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            # ./modules/nixos
            ./hosts/olympus/configuration.nix
            ./hosts/olympus/hardware-configuration.nix
            nixos-hardware.nixosModules.lenovo-thinkpad-t480
            # lix-module.nixosModules.default
            # sops-nix.nixosModules.sops
          ];
        };
      };

      deploy.nodes = {
        celestis = {
          hostname = "celestis.dropbear-monster.ts.net";
          profiles.system = {
            sshUser = "alistair";
            sshOpts = [ "-t" ];
            interactiveSudo = true;
            magicRollback = false;
            path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.celestis;
            user = "root";
          };
        };
      };
      
      homeConfigurations = {
    
        "alistair@midgard" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config
          modules = [
            ./modules/home-manager
            nix-index-database.homeModules.nix-index
            ./home-manager/common
            ./home-manager/features/gui
            ./home-manager/features/desktops/gnome.nix
            ./home-manager/hosts/midgard.nix
            ({
             nixpkgs.overlays = [inputs.nur.overlays.default ];
            })
  #          # todo: remove when https://github.com/nix-community/home-manager/pull/5355 gets merged:
  #          (builtins.fetchurl {
  #            url = "https://raw.githubusercontent.com/Smona/home-manager/nixgl-compat/modules/misc/nixgl.nix";
  #            sha256 = "f14874544414b9f6b068cfb8c19d2054825b8531f827ec292c2b0ecc5376b305";
  #          })
          ];
        };
      
        "alistair@morpheus" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config
          modules = [
            ./modules/home-manager
            nix-index-database.homeModules.nix-index
            ./home-manager/common
            ./home-manager/hosts/morpheus.nix
            ({
             nixpkgs.overlays = [inputs.nur.overlays.default ];
            })

          ];
        };
      
        "alistair@atlantis" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config
          modules = [
            ./modules/home-manager
            nix-index-database.homeModules.nix-index
            ./home-manager/common
            ./home-manager/features/gui
            ./home-manager/features/desktops/gnome.nix
            ./home-manager/hosts/atlantis.nix
            ({
             nixpkgs.overlays = [inputs.nur.overlays.default ];
            })

          ];
        };

        "alistair@borealis" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config
          modules = [
            ./modules/home-manager
            nix-index-database.homeModules.nix-index
            ./home-manager/common
            ./home-manager/hosts/borealis.nix
            ({
             nixpkgs.overlays = [inputs.nur.overlays.default ];
            })

          ];
        };
      
        "alistair@olympus" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config
          modules = [
            ./modules/home-manager
            nix-index-database.homeModules.nix-index
            ./home-manager/common
            ./home-manager/features/gui
            ./home-manager/features/desktops/gnome.nix
            ./home-manager/hosts/olympus.nix
            ({
             nixpkgs.overlays = [inputs.nur.overlays.default ];
            })

          ];
        };
      
        "alistair@khazaddum" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config
          modules = [
            ./modules/home-manager
            nix-index-database.homeModules.nix-index
            ./home-manager/common
            ./home-manager/features/gui
            ./home-manager/features/desktops/gnome.nix
            ./home-manager/hosts/khazaddum.nix
            ({
             nixpkgs.overlays = [inputs.nur.overlays.default ];
            })

          ];
        };
      };

      # This is highly advised, and will prevent many possible mistakes
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
  
}
