{
  pkgs,
  lib,
  misc,
  ...
}: {
  #
  # zsh for a better shell cause bash is rubbish
  #
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;
    #syntaxHighlighting.enable = true;

    # Enable the below for profiling zsh's startup speed. Once enabled, get numbers using: zsh -i -l -c 'zprof'
    # initContent = lib.mkOrder 500 "zmodload zsh/zprof";

    # completionInit = "autoload -U compinit && compinit -u";
    completionInit = ''
      autoload -Uz compinit
      for dump in ~/.zcompdump(N.mh+24); do
        compinit
      done

      compinit -C
    '';

    profileExtra = ''
      [ -r ~/.nix-profile/etc/profile.d/nix.sh ] && source  ~/.nix-profile/etc/profile.d/nix.sh
      export XCURSOR_PATH=$XCURSOR_PATH:/usr/share/icons:~/.local/share/icons:~/.icons:~/.nix-profile/share/icons
    '';

    antidote = {
      enable = true;
      plugins = [
        "zsh-users/zsh-completions"
        "belak/zsh-utils path:completion"
        "mhzen/zsh-sudo kind:zsh"
        # "ohmyzsh/ohmyzsh path:lib"
        # "ohmyzsh/ohmyzsh path:plugins/sudo"
      ];
    };
  };
}
