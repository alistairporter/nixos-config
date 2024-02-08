{ pkgs, misc, ... }: {
  # FEEL FREE TO EDIT: This file is NOT managed by fleek. 
  programs = {
    zsh = {
      enable = true;
      antidote = {
        enable = true;
        plugins = [
         "zsh-users/zsh-syntax-highlighting"
         "zsh-users/zsh-completions"
         "belak/zsh-utils path:completion"
         "ohmyzsh/ohmyzsh path:lib"
         "ohmyzsh/ohmyzsh path:plugins/git"
         "ohmyzsh/ohmyzsh path:plugins/lol"
         "ohmyzsh/ohmyzsh path:plugins/common-aliases"
         "ohmyzsh/ohmyzsh path:plugins/sudo"
         "ohmyzsh/ohmyzsh path:plugins/tmux"
         "ohmyzsh/ohmyzsh path:plugins/git"
        ];
      };
      #syntaxHighlighting.enable = true;
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
    };
    atuin = {
      enable = true;
      enableZshIntegration = true;
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
      '';
    };
#    nano = {
#      enable = true;
#      nanorc = ''
#        set atblanks
#        set autoindent
#        set constantshow
#        set cutfromcursor
#        set indicator
#        set linenumbers
#        set minibar
#        set showcursor
#        set softwrap
#        set speller "aspell -x -c"
#        set trimblanks
#        set whitespace "»·"
#        set zap
#        set multibuffer
#      '';
#    };
  };
 
}
