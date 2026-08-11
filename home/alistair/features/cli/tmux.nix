{pkgs, ...}: {
  # shell multiplexer
  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      catppuccin
      extrakto
      fuzzback
      prefix-highlight
      tmux-fzf
    ];
    keyMode = "vi";
    terminal = "tmux-256color";
    extraConfig = ''
      # to get all possible colours in your terminal run this command:
      # `for i in {0..255}; do printf '\033[38;5;%dmcolour%d\033[0m\n' "$i" "$i"; done`
      #

      bind-key @ choose-window 'join-pane -h -s "%%"'
      bind  c  new-window      -c "#{pane_current_path}"
      bind  %  split-window -h -c "#{pane_current_path}"
      bind '"' split-window -v -c "#{pane_current_path}"
      set -as terminal-features ",gnome*:RGB"

      # Toggle input enable/disable for the current pane and update title
      bind-key X if-shell -F '#{?pane_input_off,1,0}' \
          "select-pane -e \; select-pane -T '#{@original_pane_title}'" \
          "run-shell \"tmux set-option -p @original_pane_title \\\"\\\$(tmux display-message -p -F '#{pane_title}')\\\"\" \; select-pane -d \; select-pane -T '#{pane_title} [LOCKED]'"

      # Set the default terminal mode to 256color mode
      set -g default-terminal "screen-256color"

      # Window indexing tweaks
      set-option -g base-index 1                # window index will start with 1
      set-window-option -g pane-base-index 1    # pane index will start with 1
      set-option -g renumber-windows on

      # Increase scrollback buffer size from 2000 to 50000 lines
      set -g history-limit 50000

      # Increase tmux messages display duration from 750ms to 4s
      set -g display-time 4000

      # Refresh 'status-left' and 'status-right' more often, from every 15s to 5s
      set -g status-interval 5

      # Focus events enabled for terminals that support them
      set -g focus-events on

      # Super useful when using "grouped sessions" and multi-monitor setup
      setw -g aggressive-resize on

      # # Pane divider
      # set-window-option -g pane-border-style fg=colour11,bg=colour234
      # set-window-option -g pane-active-border-style fg=colour118,bg=colour234

      # # Cool trick: Let's dim out any pane that's not active.
      # set-window-option -g window-style fg=white,bg=colour236
      # set-window-option -g window-active-style fg=white,bg=colour235

      # # Command / Message line
      # set-window-option -g message-style fg=black,bold,bg=colour11

      # # Status Bar
      # set-option -g status-style fg=white,bg=colour089 # set status bar to white text on a mauve background
      # set-option -g status-justify centre
      # set-window-option -g window-status-style fg=colour118,bg=colour69
      # set-window-option -g window-status-current-style fg=black,bold,bg=colour011
      # set-window-option -g window-status-last-style fg=black,bold,bg=colour011
      # set-window-option -g window-status-separator |

      # # Left Side
      # # Show my active session, window, pane name or id
      # set-option -g status-left-length 50   # default 10
      # set-option -g status-left "[#[fg=white]S: #S, #[fg=colour11]W #I-#W, #[fg=colour3]P: #P #[fg=white]]"
      # # set-option -g status-left-style

      # # Right Side
      # set-option -g status-right-length 50   # default 50
      # set-option -g status-right "#[fg=grey,dim,bg=default] uptime: #(uptime | cut -f 4-5 -d\" \" | cut -f 1 -d\",\")"

      # # Enable Activity Alerts
      # set-option -g status-interval 60           # Update the status line every 60 seconds (15 is default)
      # set-window-option -g monitor-activity on   # highlights the window name in the status line
    '';
  };
}
