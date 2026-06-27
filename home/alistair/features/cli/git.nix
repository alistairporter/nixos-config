{
  pkgs,
  config,
  lib,
  private,
  ...
}: let
  # git commit --ammend but for older commits
  git-fixup = pkgs.writeShellScriptBin "git-fixup" ''
    rev="$(git rev-parse "$1")"
    git commit --fixup "$@"
    GIT_SEQUENCE_EDITOR=true git rebase -i --autostash --autosquash $rev^
  '';
in {
  home.packages = [
    git-fixup
    pkgs.git-crypt
  ];
  programs.git = {
    enable = true;

    settings = {
      alias = {
        p = "pull --ff-only";
        ff = "merge --ff-only";
        graph = "log --decorate --oneline --graph";
        pushall = "!git remote | xargs -L1 git push --all";
        add-nowhitespace = "!git diff -U0 -w --no-color | git apply --cached --ignore-whitespace --unidiff-zero -";
      };

      user = {
        name = "Alistair Porter";
        email = lib.mkDefault "alistair@${private.domain}";
      };

      init.defaultBranch = "main";
      feature.manyFiles = true;
      gpg.format = "ssh";

      merge.conflictStyle = "zdiff3";
      commit.verbose = true;
      diff.algorithm = "histogram";
      log.date = "iso";
      column.ui = "auto";
      branch.sort = "committerdate";
      # Automatically track remote branch
      push.autoSetupRemote = true;
      # Reuse merge conflict fixes when rebasing
      rerere.enabled = true;
    };

    signing = {
      format = "ssh";
      key = "~/.ssh/id_ed25519";
      signByDefault = builtins.stringLength "~/.ssh/id_ed25519" > 0;
    };

    lfs.enable = true;
    ignores = [".direnv" "result"];
  };
}
