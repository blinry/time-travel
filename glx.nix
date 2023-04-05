with import /home/blinry/wip/learn-nix-again/nixpkgs { };

stdenv.mkDerivation rec {
  name = "glx-nix";
  buildInputs = [ gcc mesa xorg.libX11 ];

  src = ./glx.c;

  #dontUnpack = true;
  unpackPhase = "true"; # We just have a single file.
  sourceRoot = "."; # Avoid an error where this variable is undefined, and default-builder.sh tries to run "cd $sourceRoot".
  buildPhase = "gcc -o glx $src -lGL -lX11 -lGLU";
  installPhase = "mkdir -p $out/bin; mv glx $out/bin";
}
