{ pkgs, lib, ... }: {

#  home.packages = [
#    # user selected packages
#    pkgs.helix
#    pkgs.rust-analyzer
#    pkgs.texlab
#    pkgs.nixd
#  ];

  programs.helix = {
    enable = true;
    defaultEditor = lib.mkDefault true; # set EDITOR envvar
    extraPackages = with pkgs; [
      rust-analyzer # rust lsp
      texlab # latex & bibtex lsp
      nil # nix lsp
      nixpkgs-fmt #nix formatter
      ruff # python lsp
      docker-compose-language-service # docker lsp
      vscode-langservers-extracted # css lsp
      superhtml # html lsp
      typescript-language-server # js ts lsp
#      vscode-json-languageserver # json lsp
      kotlin-language-server # kotlin lsp
      jdt-language-server # java lsp
      markdown-oxide # markdown lsp
    ];
    ignores = [
      ".build/"
      "!.gitignore"
    ];
    settings = {
      theme = "base16"; # set theme to one that passes through terminal colours
      editor = {
        bufferline = "multiple"; # show currently open buffers weh multiple exist
        cursorline = true; # highliegt lines with cursors
        line-number = "relative"; # use relative line numbers
        rules = [120]; #show a ruler a col 120
        lsp = {
          auto-signature-help = false; # disables popups of signature parameter help
          display-messages = true; #show lsp messages in the status line
        };
        cursor-shape = {
          # Show a bar cursor in insert mode, a block cursor in normal mode, and underline cursor in select mode
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        indent-guides = {
          # Render indentation guides
          character = "╎";
          render = true;
        };
        statusline = {
          # add git branch to status line
          left = [ "mode" "spinner" "version-control" "file-name" ];
        };
        end-of-line-diagnostics = "hint"; # Minimum severity to show a diagnostic after the end of a line
        inline-diagnostics = {
          cursor-line = "error"; # Show inline diagnostics when the cursor is on the line
          other-lines = "disable"; # Don't expand diagnostics unless the cursor is on the line
        };
      };
      keys.normal = {
        # This adds support for navigate between open buffers using Alt , and Alt ., as well as closing the current buffer with Alt w
        "A-," = "goto_previous_buffer";
        "A-." = "goto_next_buffer";
        "A-w" = ":buffer-close";
        "A-/" = "repeat_last_motion";

        # add "unselect line" with Shift x
        "A-x" = "extend_to_line_bounds";
        "X" = "select_line_above";
      };
      keys.select = {
        "A-x" = "extend_to_line_bounds";
        "X" = "select_line_above";
      };
    };
  };
}
