{ pkgs, misc, ... }: {
  programs = {

    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [ batdiff batman batgrep batwatch batpipe];
    };
    
    eza = {
      enable = true;
      enableAliases = true;
      git = true;
    };

    dircolors.enable = true;

    tmux = {
      enable = true;
      keyMode = "vi";
      terminal = "screen-256color";
      extraConfig = ''
        bind-key @ choose-window 'join-pane -h -s "%%"'
        bind  c  new-window      -c "#{pane_current_path}"
        bind  %  split-window -h -c "#{pane_current_path}"
        bind '"' split-window -v -c "#{pane_current_path}"
      '';
    };

    alacritty = {
      enable = true;
    };

    neovim = {
      enable = true;
      vimAlias = true;
      plugins = with pkgs.vimPlugins; [
#        lualine-nvim
        vim-airline
        nerdtree
      ];
      extraConfig = ''
        nnoremap <leader>n :NERDTreeFocus<CR>
        nnoremap <C-n> :NERDTree<CR>
        nnoremap <C-t> :NERDTreeToggle<CR>
        nnoremap <C-f> :NERDTreeFind<CR>
        let NERDTreeShowHidden=1
      '';

    };
  };
}
