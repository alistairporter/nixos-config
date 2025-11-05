{
  pkgs,
  config,
  ...
}: {
  imports = [
    # ./factorio.nix
    ./prism-launcher.nix
    ./steam.nix
  ];
  home = {
    packages = with pkgs; [gamescope];
    persistence = {
      "/persist".directories = [
        "Games"
        ".config/unity3d" # Unity game saves
      ];
    };
  };
}
