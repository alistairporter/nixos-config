{ pkgs, misc, ... }: {
  # FEEL FREE TO EDIT: This file is NOT managed by fleek.
  imports = [
    ../customdconf.nix
    ../sharedwithgui.nix
  ]; 
  home.sessionPath =
  [
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
  ];
 
}
