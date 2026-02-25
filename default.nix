{ pkgs ? import <nixpkgs> {} }:

let
	versionMatch = builtins.match ".*C2_TAG \"([^\"]+)\".*" (builtins.readFile (./version.h));
	strversion = if versionMatch == null then "0.0.0" else builtins.elemAt versionMatch 0;
in
pkgs.stdenv.mkDerivation {
	pname = "c2 cross assembler";
	version = strversion;

	src = ./.;

	nativeBuildInputs = with pkgs; [
		pkg-config
	];

	propagatedBuildInputs = with pkgs; [
		clang
	];

	buildPhase = ''
		make
	'';

	installPhase = ''
		make install PREFIX=$out
	'';
}
