{ pkgs, misc, ... }: {
  # FEEL FREE TO EDIT: This file is NOT managed by fleek. 
  home-manager.options.home.session.Path =
  [
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
  ];
 
}
