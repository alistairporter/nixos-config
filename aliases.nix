{ pkgs, misc, ... }: {
  # DO NOT EDIT: This file is managed by fleek. Manual changes will be overwritten.
   home.shellAliases = {
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
