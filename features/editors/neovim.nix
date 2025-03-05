{ pkgs, misc, inputs, ... }: {
  
  programs.neovim = {
    enable = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
#      lualine-nvim
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
}
