{
  description = "Nix HomeManager Configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    
    # Extra Home Manager Modules
#    xhmm.url = "github:schuelermine/xhmm";

    # Nix Index Database
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    
    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Overlays
    
    nur.url = "github:nix-community/NUR";
    
    nixGL = {
      url = "github:nix-community/nixGL/310f8e49a149e4c9ea52f1adf70cdc768ec53f8a";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
  };

  outputs = { self, nixpkgs, nix-index-database, home-manager, ... }@inputs: {
    
    # Available through 'home-manager --flake .#your-username@your-hostname'
    
    homeConfigurations = {
    
      "alistair@midgard" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config
        modules = [
          ./modules/home-manager/programs/nano.nix
          nix-index-database.homeModules.nix-index
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
          ./modules/home-manager/programs/nano.nix
          nix-index-database.homeModules.nix-index
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
          ./modules/home-manager/programs/nano.nix
          nix-index-database.homeModules.nix-index
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
          ./modules/home-manager/programs/nano.nix
          nix-index-database.homeModules.nix-index
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
          ./modules/home-manager/programs/nano.nix
          nix-index-database.homeModules.nix-index
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
          ./modules/home-manager/programs/nano.nix
          nix-index-database.homeModules.nix-index
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
  };
}
