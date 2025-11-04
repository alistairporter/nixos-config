{pkgs ? import <nixpkgs> {}, ...}: rec {
  # Misterio77's slightly customized plymouth theme, just makes the blue outline white
  plymouth-spinner-monochrome = pkgs.callPackage ./plymouth-spinner-monochrome {};

  # libadwaita xfwm theme
  adw-xfwm4 = pkgs.callPackage ./adw-xfwm4 {};
}
