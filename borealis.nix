{ pkgs, misc, ... }: {

  home.username = "alistair";
  home.homeDirectory = "/home/alistair";

  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
  ];
   
}
