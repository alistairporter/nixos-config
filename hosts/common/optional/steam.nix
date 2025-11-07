{
  pkgs,
  ...
}:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    protontricks.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    extraPackages = with pkgs; [
      gamescope
      mangohud
      gamemode
    ];
  };
}
