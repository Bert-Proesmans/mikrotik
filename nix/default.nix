{
  pkgs ? import <nixpkgs>,
}:
let
  path = builtins.path {
    path = ./.;
    name = "ros-nix-source";
  };
in
{
  lib = import ./lib { inherit (pkgs) lib; };
}
