{
  inputs,
  lib,
  pkgs,
  config,
  outputs,
  ...
}: {
  imports =
    [
      inputs.impermanence.homeManagerModules.impermanence
      ../features/cli
      ../features/helix
    ]
    ++ (builtins.attrValues outputs.homeManagerModules);

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "ca-derivations"
      ];
      warn-dirty = true;
    };
  };

  systemd.user.startServices = "sd-switch";

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  sops.age.sshKeyPaths = ["/home/alistair/.ssh/id_ed25519"];

  home = {
    username = lib.mkDefault "alistair";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "22.11";
    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.cargo/bin"
      "$HOME/.local/bin"
    ];
    file."accountimage" = {
      enable = true;
      source = ../face.png;
      target = ".face";
      force = true;
    };
    sessionVariables = {
      NH_FLAKE = "$HOME/Documents/NixConfig";
    };

    # disable impermenence for now
    persistence = lib.mkForce {};
    # persistence = {
    #   "/persist".directories = [
    #     "Documents"
    #     "Downloads"
    #     "Pictures"
    #     "Videos"
    #     ".local/bin"
    #     ".local/share/nix" # trusted settings and repl history
    #   ];
    # };
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "${config.home.homeDirectory}/Desktop";
    documents = "${config.home.homeDirectory}/Documents";
    download = "${config.home.homeDirectory}/Downloads";
    music = "${config.home.homeDirectory}/Music";
    pictures = "${config.home.homeDirectory}/Pictures";
    publicShare = "${config.home.homeDirectory}/Public";
    templates = "${config.home.homeDirectory}/Templates";
    videos = "${config.home.homeDirectory}/Videos";
    extraConfig = {
      XDG_APPIMAGE_DIR = "${config.home.homeDirectory}/AppImages";
      XDG_GIT_DIR = "${config.home.homeDirectory}/Git";
      XDG_PROJECTS_DIR = "${config.home.homeDirectory}/Projects";
      XDG_NEXTCLOUD_DIR = lib.mkIf config.services.nextcloud-client.enable "${config.home.homeDirectory}/Nextcloud";
    };
  };
}
