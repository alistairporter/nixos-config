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
           nixpkgs.overlays = [inputs.nur.overlay ];
          })

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
           nixpkgs.overlays = [inputs.nur.overlay ];
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
           nixpkgs.overlays = [inputs.nur.overlay ];
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
           nixpkgs.overlays = [inputs.nur.overlay ];
          })

        ];
      };
      
      "deck@khazaddum" = home-manager.lib.homeManagerConfiguration {
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
          ./khazaddum/deck.nix
          ./khazaddum/custom.nix
          ({
           nixpkgs.overlays = [inputs.nur.overlay ];
          })

        ];
      };
      
    };
  };
}
