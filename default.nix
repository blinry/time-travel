# I wanna use a nixpkgs version very close to this, if possible.
with import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/5bca69ac34e4b9aaa233aef75396830f42b2d3d7.tar.gz") { };

stdenv.mkDerivation rec {
  name = "glx-test";
  buildInputs = [ gcc mesa xorg.libX11 ];

  src = ./glx-test.c;

  unpackPhase = "true"; # We just have a single file as the input.
  sourceRoot = "."; # Avoid an error where this variable is undefined, but default-builder.sh tries to run "cd $sourceRoot".
  buildPhase = "gcc -g3 -o glx-test $src -lGL -lX11 -lGLU ";
  installPhase = "mkdir -p $out/bin; mv glx-test $out/bin";
  dontStrip = true;
}
