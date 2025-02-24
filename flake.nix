{
  # DO NOT EDIT: This file is managed by fleek. Manual changes will be overwritten.
  description = "Fleek Configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Extra Home Manager Modules
    xhmm.url = "github:schuelermine/xhmm";

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

  outputs = { self, nixpkgs, home-manager, xhmm, ... }@inputs: {
    
    # Available through 'home-manager --flake .#your-username@your-hostname'
    
    homeConfigurations = {
    
      "alistair@midgard" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config
        modules = [
          xhmm.homeManagerModules.all
          ./home.nix 
          ./path.nix
          ./shell.nix
          ./user.nix
          ./aliases.nix
          ./programs.nix
          # Host Specific configs
          ./customdconf.nix
          ./sharedwithgui.nix
          ./midgard/alistair.nix
          ./midgard/custom.nix
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
          ./home.nix 
          ./path.nix
          ./shell.nix
          ./user.nix
          ./aliases.nix
          ./programs.nix
          # Host Specific configs
          ./morpheus/alistair.nix
          ./morpheus/custom.nix
          # self-manage fleek
          #{
          #  home.packages = [
          #    fleek.packages.x86_64-linux.default
          #  ];
          #}
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
          ./home.nix 
          ./path.nix
          ./shell.nix
          ./user.nix
          ./aliases.nix
          ./programs.nix
          # Host Specific configs
          ./atlantis/alistair.nix
          ./atlantis/custom.nix
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
          ./home.nix 
          ./path.nix
          ./shell.nix
          ./user.nix
          ./aliases.nix
          ./programs.nix
          # Host Specific configs
          ./borealis/alistair.nix
          ./borealis/custom.nix
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
          ./home.nix 
          ./path.nix
          ./shell.nix
          ./user.nix
          ./aliases.nix
          ./programs.nix
          # Host Specific configs
          ./customdconf.nix
          ./sharedwithgui.nix
          ./olympus/alistair.nix
          ./olympus/custom.nix
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
          ./home.nix 
          ./path.nix
          ./shell.nix
          ./user.nix
          ./aliases.nix
          ./programs.nix
          # Host Specific configs
          ./customdconf.nix
          ./sharedwithgui.nix
          ./khazaddum/alistair.nix
          ./khazaddum/custom.nix
          ({
           nixpkgs.overlays = [inputs.nur.overlays.default ];
          })

        ];
      };
      
    };
  };
}
