# zig.nix
{ pkgs ? import <nixpkgs> {} }:

let
	zig = pkgs.stdenv.mkDerivation rec {
		pname = "zig";
		version = "master";

		src = pkgs.fetchurl {
			url = "https://ziglang.org/builds/zig-linux-x86_64-0.14.0-dev.2321+6cf01a679.tar.xz";
			sha256 = "sha256-13bplUJpTdwh3pWNLQw0erWxZ+5Qkiz++TDeO0DjMyI=";
		};


		installPhase = ''
			mkdir -p $out/bin
			cp -r ./ $out/bin
		'';

	};
in
	pkgs.mkShell {
		buildInputs = [ zig ];

		shellHook = ''
		echo "Development environment ready with Zig 0.14.0!"
		'';
	}
