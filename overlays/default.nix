{
  outputs,
  inputs,
}: let
  addPatches = pkg: patches:
    pkg.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or []) ++ patches;
    });
in {
  # For every flake input, aliases 'pkgs.inputs.${flake}' to
  # 'inputs.${flake}.packages.${pkgs.system}' or
  # 'inputs.${flake}.legacyPackages.${pkgs.system}'
  flake-inputs = final: _: {
    inputs =
      builtins.mapAttrs (
        _: flake: let
          legacyPackages = (flake.legacyPackages or {}).${final.system} or {};
          packages = (flake.packages or {}).${final.system} or {};
        in
          if legacyPackages != {}
          then legacyPackages
          else packages
      )
      inputs;
  };

  # Adds my custom packages
  additions = final: prev:
    import ../pkgs {pkgs = final;}
    // {
      # formats = (prev.formats or {}) // import ../pkgs/formats {pkgs = final;};
      # vimPlugins = (prev.vimPlugins or {}) // import ../pkgs/vim-plugins {pkgs = final;};
    };

  # Modifies existing packages
  modifications = final: prev: {
    # wl-clipboard = addPatches prev.wl-clipboard [./wl-clipboard-secrets.diff];

    # pass = addPatches prev.pass [./pass-wlclipboard-secret.diff];

    # vdirsyncer = addPatches prev.vdirsyncer [./vdirsyncer-fixed-oauth-token.patch];

    # # https://github.com/pimutils/todoman/pull/594
    # todoman = addPatches prev.todoman [./todoman-latest-main.patch ./todoman-subtasks.patch];

    # https://github.com/ValveSoftware/gamescope/issues/1622
    gamescope = prev.gamescope.overrideAttrs (_: {
      NIX_CFLAGS_COMPILE = ["-fno-fast-math"];
    });

    adw-gtk3 = prev.adw-gtk3.overrideAttrs (old: {
      postInstall = (old.postInstall or "") + ''
        find $out/share/themes -type d -name "gtk-4.0" -exec rm -rf {} +
      '';
    });
  };

  unstable-backport = final: prev: {
    atuin = inputs.nixpkgs-unstable.legacyPackages.${final.system}.atuin;
  };
}
