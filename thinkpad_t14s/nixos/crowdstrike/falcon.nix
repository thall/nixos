{ pkgs, stdenv, lib, dpkg, zlib, fetchFromGitHub, ... }:

let
  version = "6.54.0";
  build = "15110";
  arch = "amd64";

in

stdenv.mkDerivation rec {
  name = "falcon-sensor";

  buildInputs = [ dpkg zlib ];

  sourceRoot = ".";

  src = ./${name}_${version}-${build}_${arch}.deb;

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    mkdir $out
    cp -r . $out
  '';

  meta = with lib; {
    description = "Crowdstrike Falcon Sensor";
    homepage    = "https://www.crowdstrike.com/";
    license     = licenses.unfree;
    platforms   = platforms.linux;
    maintainers = with maintainers; [];
  };
}
