{
  # shell multiplexer
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    terminal = "tmux-256color";
    extraConfig = ''
      bind-key @ choose-window 'join-pane -h -s "%%"'
      bind  c  new-window      -c "#{pane_current_path}"
      bind  %  split-window -h -c "#{pane_current_path}"
      bind '"' split-window -v -c "#{pane_current_path}"
      set -as terminal-features ",gnome*:RGB"
    '';
  };
}
