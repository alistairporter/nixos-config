{ pkgs, config, lib,  ... }: {
  imports = [
    ./shell
    ./helix.nix
    ./nano.nix
    ./thefuck.nix
    ./nix-your-shell.nix
    ./utilities.nix
    ./ssh.nix
    ./git.nix    
  ];
  
  home = {
    stateVersion = "22.11"; # To figure this out (in-case it changes) you can comment out the line and see what version it expected.
    username = lib.mkDefault "alistair";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.cargo/bin"
      "$HOME/.local/bin"
    ];
  };

   
  xdg = {
    enable = true;
  }; 

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
  };
  
  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);      
    };
  };

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };
  
}
