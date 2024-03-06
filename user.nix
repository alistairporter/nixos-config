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
    eza = {
      enable = true;
      enableAliases = true;
      git = true;
    };
    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [ batdiff batman batgrep batwatch batpipe];
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = { 
        add_newline = true;
        character = {
          error_symbol = "[λ](bold red)";
          success_symbol = "[λ](bold green)";
        };
        cmd_duration.min_time = 60000;

        directory = { 
          format = "\\[[$path]($style)\\][$read_only]($read_only_style) ";
          read_only = " ro";
        };

        format = "$character$username$hostname$all→ ";

        git_branch.symbol = "git ";
        git_commit.tag_symbol = " tag ";
        git_status = { 
          ahead = ">";
          behind = "<";
          deleted = "x";
          diverged = "<>";
          renamed = "r";
        };

        hostname = {
          disabled = false;
          format = " [$ssh_symbol](bold red)\\[[$hostname](green)\\] ";
          ssh_only = false;
          ssh_symbol = "remote ";
          style = "green bold";
          trim_at = "";
        };

        line_break.disabled = true;

        status.symbol = "[x](bold red) ";

        username = {
          disabled = false;
          format = "[$user]($style)";
          show_always = true;
          style_root = "red bold";
          style_user = "yellow bold";
        };

        # overide default icons with sensible text
        aws.symbol = "aws "; azure.symbol = "az "; bun.symbol = "bun "; c.symbol = "C "; cmake.symbol = "cmake "; cobol.symbol = "cobol "; conda.symbol = "conda "; crystal.symbol = "cr "; daml.symbol = "daml "; dart.symbol = "dart "; deno.symbol = "deno "; docker_context.symbol = "docker "; dotnet.symbol = ".NET "; elixir.symbol = "exs "; elm.symbol = "elm "; fennel.symbol = "fnl "; fossil_branch.symbol = "fossil "; gcloud.symbol = "gcp "; golang.symbol = "go "; gradle.symbol = "gradle "; guix_shell.symbol = "guix "; hg_branch.symbol = "hg "; java.symbol = "java "; julia.symbol = "jl "; kotlin.symbol = "kt "; lua.symbol = "lua "; memory_usage.symbol = "memory "; meson.symbol = "meson "; nim.symbol = "nim "; nix_shell.symbol = "nix "; nodejs.symbol = "nodejs "; ocaml.symbol = "ml "; opa.symbol = "opa "; package.symbol = "pkg "; perl.symbol = "pl "; php.symbol = "php "; pijul_channel.symbol = "pijul "; pulumi.symbol = "pulumi "; purescript.symbol = "purs "; python.symbol = "py "; raku.symbol = "raku "; ruby.symbol = "rb "; rust.symbol = "rs "; scala.symbol = "scala "; solidity.symbol = "solidity "; spack.symbol = "spack "; sudo.symbol = "sudo "; swift.symbol = "swift "; terraform.symbol = "terraform "; zig.symbol = "zig ";
        os.symbols = { Alpaquita = "alq "; Alpine = "alp "; Amazon = "amz "; Android = "andr "; Arch = "rch "; Artix = "atx "; CentOS = "cent "; Debian = "deb "; DragonFly = "dfbsd "; Emscripten = "emsc "; EndeavourOS = "ndev "; Fedora = "fed "; FreeBSD = "fbsd "; Garuda = "garu "; Gentoo = "gent "; HardenedBSD = "hbsd "; Illumos = "lum "; Linux = "lnx "; Mabox = "mbox "; Macos = "mac "; Manjaro = "mjo "; Mariner = "mrn "; MidnightBSD = "mid "; Mint = "mint "; NetBSD = "nbsd "; NixOS = "nix "; OpenBSD = "obsd "; OpenCloudOS = "ocos "; OracleLinux = "orac "; Pop = "pop "; Raspbian = "rasp "; RedHatEnterprise = "rhel "; Redhat = "rhl "; Redox = "redox "; SUSE = "suse "; Solus = "sol "; Ubuntu = "ubnt "; Unknown = "unk "; Windows = "win "; openEuler = "oeul "; openSUSE = "osuse ";
        };
      };
    };
    tmux = {
      enable = true;
      keyMode = "vi";
      terminal = "screen-256color";
      extraConfig = ''
        bind-key @ choose-window 'join-pane -h -s "%%"'
      '';
    };
    atuin = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        sync_address = "https://atuin.aporter.xyz";
        sync_frequency = "0";
        search_mode = "fulltext";
        filter_mode_shell_up_key_binding = "session";
        enter_accept = false;
      };
    };
    alacrity = {
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

  home.file = {
    ".nanorc" = {
      enable = true;
      target = "./";
      text = ''
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
  xdg = {
    enable = true;
  }; 
}
