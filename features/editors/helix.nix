{ pkgs, misc, ... }: {

  home.packages = [
    # user selected packages
    pkgs.helix
    pkgs.rust-analyzer
    pkgs.texlab
  ];
}
