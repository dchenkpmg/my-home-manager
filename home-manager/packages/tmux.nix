{ pkgs, ... }:
pkgs.stdenv.mkDerivation rec {
  name = "tmux";
  src = pkgs.fetchFromGitHub {
    owner = "tmux";
    repo = "tmux";
    rev = "865117a05fa1e850da07f67b422a469ee58fe019";
    sha256 = "sha256-hjiNXGMlUC+jjPvw9a6EXUAGuHbGwRFY0cGi4/K+lak=";
  };
  nativeBuildInputs = with pkgs; [ autoconf automake libtool ];
  buildInputs = with pkgs; [ ncurses ];
  unpackPhase = ''
    runHook preUnpack
    cd ${src}
    ./autogen.sh
    runHook postUnpack
  '';
  configurePhase = ''
    runHook configurePhase
    ./configure \
      --prefix=$out
    '';
  installPhase = ''
    make
  '';
}
