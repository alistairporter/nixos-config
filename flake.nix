{
  description = "My nixos systems in a flake!";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";

    # use the following for unstable:
    # nixpkgs.url = "nixpkgs/nixos-unstable";

    # or any branch you want:
    # nixpkgs.url = "nixpkgs/{BRANCH-NAME}";

    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { self, nixpkgs, sops-nix, ... }:
    let
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        borealis = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration.nix
            sops-nix.nixosModules.sops
          ];
      };
    };
  };
}
