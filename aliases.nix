{ pkgs, misc, ... }: {
  # DO NOT EDIT: This file is managed by fleek. Manual changes will be overwritten.
   home.shellAliases = {
    "apply-atlantis" = "nix run --impure home-manager/master -- -b bak switch --flake .#alistair@atlantis";
    
    "apply-khazaddum" = "nix run --impure home-manager/master -- -b bak switch --flake .#deck@khazaddum";
    
    "apply-midgard" = "nix run --impure home-manager/master -- -b bak switch --flake .#alistair@midgard";
    
    "apply-morpheus" = "nix run --impure home-manager/master -- -b bak switch --flake .#alistair@morpheus";
    
    "apply-olympus" = "nix run --impure home-manager/master -- -b bak switch --flake .#alistair@olympus";
    
    "cp" = "cp -i";
    
    "dud" = "du -d 1 -h";
    
    "fleeks" = "cd ~/.local/share/fleek";
    
    "l" = "ls -lh";
    
    "latest-fleek-version" = "nix run https://getfleek.dev/latest.tar.gz -- version";
    
    "lsa" = "ls -lah";
    
    "mv" = "mv -i";
    
    "neofetch" = "fastfetch";
    
    "t" = "tail -f";
    
    "update-fleek" = "nix run https://getfleek.dev/latest.tar.gz -- update";
    };
}
