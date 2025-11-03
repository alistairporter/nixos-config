{ pkgs, lib, ... }:
let
  cfg = cfg.lix;
in
{
  options = {
    lix.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Use lix as the system nix implementation and apply overlays to some stubborn packages.";
      default = false;
    };
  };

  config = {
    # force any recalictant packages to use lix using an overlay.
    nixpkgs.overlays = [ (final: prev: {
      my-new-package = prev.my-new-package.override {
        nix = final.lixPackageSets.stable.lix;
      }; # Adapt to your specific use case.

      inherit (final.lixPackageSets.stable)
        # nixpkgs-review
        # nix-direnv
        nix-eval-jobs
        nix-fast-build
        colmena;
        
      nixpkgs-review = prev.nixpkgs-review;
      nix-direnv = prev.nix-direnv;
    }) ];
    # lix as nix package
    nix.package = pkgs.lixPackageSets.stable.lix;
  };
}

