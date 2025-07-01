{ pkgs, misc, ... }: {

#
# shell aliases
#
  home.shellAliases = {
    "apply-atlantis" = "nix run --impure home-manager/master -- -b bak switch --flake .#alistair@atlantis";
    
    "apply-khazaddum" = "nix run --impure home-manager/master -- -b bak switch --flake .#deck@khazaddum";
    
    "apply-midgard" = "nix run --impure home-manager/master -- -b bak switch --flake .#alistair@midgard";
    
    "apply-morpheus" = "nix run --impure home-manager/master -- -b bak switch --flake .#alistair@morpheus";
    
    "apply-olympus" = "nix run --impure home-manager/master -- -b bak switch --flake .#alistair@olympus";
    
    "cp" = "cp -i";
    
    "dud" = "du -d 1 -h";
    
#    "fleeks" = "cd ~/.local/share/fleek";
    "fleeks" = "echo 'fleek is no more, the git repo is now located at ~/.config/home-manager and no you dont get a nice shortcut either'";

    "fleek" = "echo 'fleek is no more, you need to manually sync the git repo at ~/.config/home-manager and use home-manager switch to apply instead!'";
    
    "l" = "ls -lh";
    
#    "latest-fleek-version" = "nix run https://getfleek.dev/latest.tar.gz -- version";
    
    "lsa" = "ls -lah";
    
    "mv" = "mv -i";
    
    "neofetch" = "fastfetch";
    
    "t" = "tail -f";
  };
}
