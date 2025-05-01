# zig.nix
{ pkgs ? import <nixpkgs> {} }:

let
  zig = pkgs.stdenv.mkDerivation {
    pname = "zig";
    version = "master";

    src = pkgs.fetchurl {
      url = "https://ziglang.org/builds/zig-linux-x86_64-0.15.0-dev.386+2e35fdd03.tar.xz";
      sha256 = "sha256-vDTsEp8vUDYQdKmtIZwF8GFNKShz5DgTvbQ7FHWKf/Q=";
    };


    installPhase = ''
      mkdir -p $out/bin
      cp -r ./ $out/bin
    '';

  };
in
  pkgs.mkShell {
    buildInputs = [ zig ];

    packages = with pkgs; [
      gdb
    ];

    shellHook = ''
    echo "Development environment ready with Zig 0.15.0!"
    '';
  }
