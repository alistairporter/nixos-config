{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./fonts.nix
    ./gtk.nix
    ./ptyxis.nix
    ./remmina.nix
    ./zen.nix
  ];

  home.packages = with pkgs; [
    xdg-terminal-exec-mkhl # required for some gnome features to work regarding terminals.
    libnotify # notififcations stuff
    vlc # swissarmy knife of video and audio
    bitwarden-cli # cli passwords
    bitwarden-desktop # passwords
    obsidian # notes
    mission-center # taskmanager
    ruffle # adobe flash compat
    sqlitebrowser # sqlite stuff
    tremotesf # transmission remote client
    dconf-editor # dconf editor
  ];

  # # Also sets org.freedesktop.appearance color-scheme
  # dconf.settings."org/gnome/desktop/interface".color-scheme =
  #   if config.colorscheme.mode == "dark"
  #   then "prefer-dark"
  #   else if config.colorscheme.mode == "light"
  #   then "prefer-light"
  #   else "default";

}
