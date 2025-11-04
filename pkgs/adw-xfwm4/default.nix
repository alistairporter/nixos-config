{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "adw-xfwm4";
  version = "b0b163bac7d74e5c2d69451d9b1315389bb3c361";  # you can encode date or commit hash

  src = fetchFromGitHub {
    owner = "FabianOvrWrt";
    repo = "adw-xfwm4";
    rev = "b0b163bac7d74e5c2d69451d9b1315389bb3c361";
    sha256 = "sha256-NSpISiwZQ9wt4lHNmA7lluOZiWPd9Dhe4i1iUTqg3Dg=";
  };

  nativeBuildInputs = [];

  # no build needed (just install)
  installPhase = ''
    mkdir -p $out/share/themes
    cp -r themes/* $out/share/themes/
    mkdir -p $out/share/pixmaps
    cp -r pixmaps/* $out/share/pixmaps/ || true
  '';

  meta = with lib; {
    description = "Libadwaita-style xfwm4 window-decoration theme";
    homepage = "https://github.com/FabianOvrWrt/adw-xfwm4";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ alistairporter ];
    platforms = platforms.linux;
  };
}

