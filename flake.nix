{
  description = "My nixos systems in a flake!";

  inputs = {
    # Nixpkgs:
    #
    # use the following for unstable:
    # nixpkgs.url = "nixpkgs/nixos-unstable";

    # or any branch you want:
    # nixpkgs.url = "nixpkgs/{BRANCH-NAME}";
    #

    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable"; # allow access to newer packages from unstable though overlay at 'overlays/default.nix'

    systems.url = "github:nix-systems/default-linux";

    # Hardware configs by nixos community optimal for various machines.
    hardware.url = "github:NixOS/nixos-hardware/master";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      # https://github.com/nix-community/impermanence/pull/272#discussion_r2230796215
      url = "github:misterio77/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # SOPS secret managment
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixVirt
    nixvirt = {
      url = "https://flakehub.com/f/AshleyYakeley/NixVirt/0.5.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix Index Database
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS Secureboot
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      # url = "github:youwen5/zen-browser-flake";
      url = "github:0xc000022070/zen-browser-flake";
      # as of 20251102, needs 'libgbm' which is only in unstable-nixpkgs
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gl = {
      url = "github:nix-community/nixgl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Overlays

    nur.url = "github:nix-community/NUR";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    systems,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    forEachSystem = f: lib.genAttrs (import systems) (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs (import systems) (
      system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
    );
  in {
    inherit lib;

    # Import my nixos and home-manager modules
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    # Import package overlays
    overlays = import ./overlays {inherit inputs outputs;};
    # Hydra stuff
    hydraJobs = import ./hydra.nix {inherit inputs outputs;};

    # My custom packages, Accessible through 'nix build', 'nix shell', etc
    packages = forEachSystem (pkgs: import ./pkgs {inherit pkgs;});
    devShells = forEachSystem (pkgs: import ./shell.nix {inherit pkgs;});

    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forEachSystem (pkgs: pkgs.alejandra);

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      # Main NAS and app/media server
      atlantis = lib.nixosSystem {
        modules = [./hosts/atlantis];
        specialArgs = {
          inherit inputs outputs;
        };
      };
      # Secondary app server in 1L minipc
      borealis = lib.nixosSystem {
        modules = [./hosts/borealis];
        specialArgs = {
          inherit inputs outputs;
        };
      };
      # Main laptop
      midgard = lib.nixosSystem {
        modules = [./hosts/midgard];
        specialArgs = {
          inherit inputs outputs;
        };
      };
      # VPS and reverse proxy/tertiary appserver
      morpheus = lib.nixosSystem {
        modules = [./hosts/morpheus];
        specialArgs = {
          inherit inputs outputs;
        };
      };
      # Main desktop and gaming rig
      olympus = lib.nixosSystem {
        modules = [./hosts/olympus];
        specialArgs = {
          inherit inputs outputs;
        };
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "alistair@khazaddum" = lib.homeManagerConfiguration {
        modules = [./home/alistair/khazaddum.nix ./home/alistair/nixpkgs.nix];
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
        };
      };
    };
  };
}
