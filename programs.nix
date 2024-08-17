{ pkgs, misc, inputs, ... }: {

#  imports = [inputs.xhmm.homeManagerModules.console.nano];
  
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

    nano = {
      enable = true;
      config = ''
        set atblanks
        set autoindent
        set constantshow
        set cutfromcursor
        set indicator
        set linenumbers
        set minibar
        set showcursor
        set softwrap
        set speller "aspell -x -c"
        set trimblanks
        set whitespace "»·"
        set zap
        set multibuffer
      '';
    };
  };
}
