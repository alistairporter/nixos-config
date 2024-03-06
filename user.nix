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
      settings = {
        '''
        add_newline = true

        format = "$character$username$hostname$all→ "

        [username]
        style_user = 'yellow bold'
        style_root = 'red bold'
        format = '[$user]($style)'
        disabled = false
        show_always = true

        [hostname]
        ssh_only = false
        format = ' [$ssh_symbol](bold red)\[[$hostname](green)\] '
        trim_at = ''
        style = "green bold"
        ssh_symbol = "remote "
        disabled = false

        [line_break]
        disabled = true

        [character]
        success_symbol = "[λ](bold green)"
        error_symbol = "[λ](bold red)"

        [cmd_duration]
        min_time = 60_000

        [directory]
        format = '\[[$path]($style)\][$read_only]($read_only_style) '
        read_only = " ro"

        [git_commit]
        tag_symbol = " tag "

        [git_status]
        ahead = ">"
        behind = "<"
        diverged = "<>"
        renamed = "r"
        deleted = "x"

        [aws]
        symbol = "aws "

        [azure]
        symbol = "az "

        [bun]
        symbol = "bun "

        [c]
        symbol = "C "

        [cobol]
        symbol = "cobol "

        [conda]
        symbol = "conda "

        [crystal]
        symbol = "cr "

        [cmake]
        symbol = "cmake "

        [daml]
        symbol = "daml "

        [dart]
        symbol = "dart "

        [deno]
        symbol = "deno "

        [dotnet]
        symbol = ".NET "

        #[directory]
        #read_only = " ro"

        [docker_context]
        symbol = "docker "

        [elixir]
        symbol = "exs "

        [elm]
        symbol = "elm "

        [fennel]
        symbol = "fnl "

        [fossil_branch]
        symbol = "fossil "

        [gcloud]
        symbol = "gcp "

        [git_branch]
        symbol = "git "

        [golang]
        symbol = "go "

        [gradle]
        symbol = "gradle "

        [guix_shell]
        symbol = "guix "

        [hg_branch]
        symbol = "hg "

        [java]
        symbol = "java "

        [julia]
        symbol = "jl "

        [kotlin]
        symbol = "kt "

        [lua]
        symbol = "lua "

        [nodejs]
        symbol = "nodejs "

        [memory_usage]
        symbol = "memory "

        [meson]
        symbol = "meson "

        [nim]
        symbol = "nim "

        [nix_shell]
        symbol = "nix "

        [ocaml]
        symbol = "ml "

        [opa]
        symbol = "opa "

        [os.symbols]
        Alpaquita = "alq "
        Alpine = "alp "
        Amazon = "amz "
        Android = "andr "
        Arch = "rch "
        Artix = "atx "
        CentOS = "cent "
        Debian = "deb "
        DragonFly = "dfbsd "
        Emscripten = "emsc "
        EndeavourOS = "ndev "
        Fedora = "fed "
        FreeBSD = "fbsd "
        Garuda = "garu "
        Gentoo = "gent "
        HardenedBSD = "hbsd "
        Illumos = "lum "
        Linux = "lnx "
        Mabox = "mbox "
        Macos = "mac "
        Manjaro = "mjo "
        Mariner = "mrn "
        MidnightBSD = "mid "
        Mint = "mint "
        NetBSD = "nbsd "
        NixOS = "nix "
        OpenBSD = "obsd "
        OpenCloudOS = "ocos "
        openEuler = "oeul "
        openSUSE = "osuse "
        OracleLinux = "orac "
        Pop = "pop "
        Raspbian = "rasp "
        Redhat = "rhl "
        RedHatEnterprise = "rhel "
        Redox = "redox "
        Solus = "sol "
        SUSE = "suse "
        Ubuntu = "ubnt "
        Unknown = "unk "
        Windows = "win "

        [package]
        symbol = "pkg "

        [perl]
        symbol = "pl "

        [php]
        symbol = "php "

        [pijul_channel]
        symbol = "pijul "

        [pulumi]
        symbol = "pulumi "

        [purescript]
        symbol = "purs "

        [python]
        symbol = "py "

        [raku]
        symbol = "raku "

        [ruby]
        symbol = "rb "

        [rust]
        symbol = "rs "

        [scala]
        symbol = "scala "

        [spack]
        symbol = "spack "

        [solidity]
        symbol = "solidity "

        [status]
        symbol = "[x](bold red) "

        [sudo]
        symbol = "sudo "

        [swift]
        symbol = "swift "

        [terraform]
        symbol = "terraform "

        [zig]
        symbol = "zig "
        '''
      };
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
        let NERDTreeShowHidden=1
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
