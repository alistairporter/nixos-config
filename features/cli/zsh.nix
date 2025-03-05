{ pkgs, misc, ... }: {
#
# zsh for a better shell cause bash is rubbish
#
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    completionInit = "autoload -U compinit && compinit -u";
    profileExtra = ''
      [ -r ~/.nix-profile/etc/profile.d/nix.sh ] && source  ~/.nix-profile/etc/profile.d/nix.sh
      export XCURSOR_PATH=$XCURSOR_PATH:/usr/share/icons:~/.local/share/icons:~/.icons:~/.nix-profile/share/icons
    '';
    antidote = {
      enable = true;
      plugins = [
#       "zsh-users/zsh-syntax-highlighting"
       "zsh-users/zsh-completions"
       "belak/zsh-utils path:completion"
       "ohmyzsh/ohmyzsh path:lib"
#       "ohmyzsh/ohmyzsh path:plugins/git"
#       "ohmyzsh/ohmyzsh path:plugins/lol"
#       "ohmyzsh/ohmyzsh path:plugins/common-aliases"
       "ohmyzsh/ohmyzsh path:plugins/sudo"
#       "ohmyzsh/ohmyzsh path:plugins/tmux"
#       "ohmyzsh/ohmyzsh path:plugins/git"
#       "ohmyzsh/ohmyzsh path:plugins/docker"
      ];
    };
    #syntaxHighlighting.enable = true;
  };
}
