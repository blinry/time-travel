# I wanna use a nixpkgs version very close to this, if possible.
with import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/5bca69ac34e4b9aaa233aef75396830f42b2d3d7.tar.gz") { };

let
  /* copied and modified from the version in the nixpkgs specified above */
  mesaCustom = stdenv.mkDerivation {
    name = "mesa-7.0.1";

    src = fetchurl {
      url = mirror://sourceforge/mesa3d/MesaLib-7.0.1.tar.bz2;
      md5 = "c056abd763e899114bf745c9eedbf9ad";
    };
  /*    (fetchurl {
        url = http://nix.cs.uu.nl/dist/tarballs/MesaGLUT-6.4.tar.bz2;
        md5 = "1a8c4d4fc699233f5fdb902b8753099e";
      })
      (fetchurl {
        url = http://nix.cs.uu.nl/dist/tarballs/MesaDemos-6.4.tar.bz2;
        md5 = "1a8c4d4fc699233f5fdb902b8753099e";
      }) */

    buildFlags = "linux-x86-64"; /* instead of linux-dri-x86-64 */

    preBuild = "
      makeFlagsArray=(INSTALL_DIR=$out DRI_DRIVER_INSTALL_DIR=$out/lib/modules/dri SHELL=$SHELL)
    ";

    buildInputs = [
      pkgconfig x11 xlibs.makedepend libdrm xlibs.glproto xlibs.libXmu
      xlibs.libXi xlibs.libXxf86vm xlibs.libXfixes xlibs.libXdamage
    ];

    passthru = {inherit libdrm;};

    meta = {
      description = "OpenGL-compatible 3D library. Supports acceleration.";
      homepage = http://www.mesa3d.org/;
    };
  };
in

stdenv.mkDerivation rec {
  name = "glx-test";
  buildInputs = [ gcc mesaCustom xorg.libX11 ];

  src = ./glx-test.c;

  unpackPhase = "true"; # We just have a single file as the input.
  sourceRoot = "."; # Avoid an error where this variable is undefined, but default-builder.sh tries to run "cd $sourceRoot".
  buildPhase = "gcc -g3 -o glx-test $src -lGL -lX11 -lGLU ";
  installPhase = "mkdir -p $out/bin; mv glx-test $out/bin";
  dontStrip = true;
}
