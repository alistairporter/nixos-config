{ config, pkgs, lib, inputs, misc, ... }: 
#
#let
##  githooks = inputs.githooks.packages."${pkgs.system}".default;
#  nixGLIntel = inputs.nixGL.packages."${pkgs.system}".nixGLIntel;
#in
#rec {
{
  # FEEL FREE TO EDIT: This file is NOT managed by fleek. 
  programs.zsh.initExtraBeforeCompInit = ''
    fpath+=(/usr/share/zsh/site-functions /usr/share/zsh/$ZSH_VERSION/functions /usr/share/zsh/vendor-completions)
  '';
  programs.zsh.initExtra = ''
    any-nix-shell zsh --info-right | source /dev/stdin
  '';
#
#  imports = [
#    (builtins.fetchurl {
#      url = "https://raw.githubusercontent.com/Smona/home-manager/nixgl-compat/modules/misc/nixgl.nix";
#      sha256 = "01dkfr9wq3ib5hlyq9zq662mp0jl42fw3f6gd2qgdf8l8ia78j7i";
#    })
#  ];
#  
#  services.nextcloud-client = {
#    enable = true;
#    package = (config.lib.nixGL.wrap pkgs.nextcloud-client);
#  };
#
#  systemd.user.services = {
#    nextcloud-client = {
#      Unit = {
#        After = "graphical-session-pre.target";
#        Description = "Nextcloud Client";
#        PartOf = "graphical-session.target";
#      };
#      Service = {
#        Environment = "PATH=/home/alistair/.nix-profile/bin";
#        ExecStart = "${nixGLIntel}/bin/nixGLIntel ${pkgs.nextcloud-client}/bin/nextcloud";
#      };
#    };
#  };

  #nixGL.prefix = "${nixGLIntel}/bin/nixGLIntel";

#  home.packages = [ nixGLIntel pkgs.sops ];
  home.packages = [ pkgs.sops pkgs.any-nix-shell ];
}
