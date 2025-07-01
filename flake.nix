{
  description = "My nixos configurations in a flake!";

  inputs = {
  
    nixpkgs.url = "nixpkgs/nixos-24.11";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Add deploy-rs as Flake input from GitHub
    deploy-rs.url = "github:serokell/deploy-rs";
    
    sops-nix.url = "github:Mic92/sops-nix";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    }; 

    nixvirt = {
      url = "https://flakehub.com/f/AshleyYakeley/NixVirt/0.5.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Extra Home Manager Modules
    xhmm.url = "github:schuelermine/xhmm";

    # Nix Index Database
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    
    # Home manager
    home-manager.url = "https://flakehub.com/f/nix-community/home-manager/0.1.tar.gz";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Overlays
    
    nur.url = "github:nix-community/NUR";
    
    nixGL = {
      url = "github:nix-community/nixGL/310f8e49a149e4c9ea52f1adf70cdc768ec53f8a";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, deploy-rs, sops-nix, lix-module, nixvirt, xhmm, nix-index-database, home-manager, nur, ... }@inputs: {
  
    nixosConfigurations = {
    
      celestis = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          #nixos-hardware.nixosModules.raspberry-pi-3
          ./modules/raspberry-pi/3/default.nix
          ./celestis/configuration.nix
          #lix-module.nixosModules.default
          sops-nix.nixosModules.sops
        ];
      };
        
      borealis = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./borealis/configuration.nix
          lix-module.nixosModules.default
          sops-nix.nixosModules.sops
        ];
      };
        
      atlantis = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./atlantis/configuration.nix
          sops-nix.nixosModules.sops
          lix-module.nixosModules.default
          nixvirt.nixosModules.default
        ];
      };

      morpheus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./morpheus/configuration.nix
          lix-module.nixosModules.default
          sops-nix.nixosModules.sops
        ];
      };    
    };

  homeConfigurations = {
  
    "alistair@midgard" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
      extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config
      modules = [
        xhmm.homeManagerModules.all
        nix-index-database.hmModules.nix-index
        ./common
        ./features/gui
        ./features/desktops/gnome.nix
        ./nixpkgs.nix
        ./midgard.nix
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
        xhmm.homeManagerModules.all
        nix-index-database.hmModules.nix-index
        ./common
        ./nixpkgs.nix
        ./morpheus.nix
        ({
         nixpkgs.overlays = [inputs.nur.overlays.default ];
        })

      ];
    };
    
    "alistair@atlantis" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
      extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config
      modules = [
        xhmm.homeManagerModules.all
        nix-index-database.hmModules.nix-index
        ./common
        ./nixpkgs.nix
        ./features/gui
        ./features/desktops/gnome.nix
        ./atlantis.nix
        ({
         nixpkgs.overlays = [inputs.nur.overlays.default ];
        })

      ];
    };

    "alistair@borealis" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
      extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config
      modules = [
        xhmm.homeManagerModules.all
        nix-index-database.hmModules.nix-index
        ./common
        ./nixpkgs.nix
        ./borealis.nix
        ({
         nixpkgs.overlays = [inputs.nur.overlays.default ];
        })

      ];
    };
    
    "alistair@olympus" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
      extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config
      modules = [
        xhmm.homeManagerModules.all
        nix-index-database.hmModules.nix-index
        ./common
        ./nixpkgs.nix
        ./features/gui
        ./features/desktops/gnome.nix
        ./olympus.nix
        ({
         nixpkgs.overlays = [inputs.nur.overlays.default ];
        })

      ];
    };
    
    "alistair@khazaddum" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
      extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config
      modules = [
        xhmm.homeManagerModules.all
        nix-index-database.hmModules.nix-index
        ./common
        ./nixpkgs.nix
        ./features/gui
        ./features/desktops/gnome.nix
        ./khazaddum.nix
        ({
         nixpkgs.overlays = [inputs.nur.overlays.default ];
        })

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
