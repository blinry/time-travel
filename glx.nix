with import <nixpkgs> { };

stdenv.mkDerivation rec {
  name = "glx nix";
  buildInputs = [ clang libGL xorg.libX11 libGLU ];

  src = ./glx.c;

  dontUnpack = true;
  buildPhase = "clang -o glx $src -lGL -lX11 -lGLU";
  installPhase = "mkdir -p $out/bin; mv glx $out/bin";
}
