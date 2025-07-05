{ inputs, lib, config, ...}:{

  nix = {
    settings = {
      trusted-users = [
        "root"
        "@wheel"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = true;
    };

    gc = {
      automatic = true;
      dates = lib.mkDefault "weekly";
      options = "--delete-older-than 5";
    };

    optimise = {
      automatic = true;
      dates = [ "03:45" ];
    };
  };
}
