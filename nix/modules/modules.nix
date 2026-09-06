{
  pkgs,
  lib,

  # Whether to enable module type checking.
  check ? true,

  # Whether to only import the required modules, and let the user add modules
  # manually
  minimal ? false,
}:

let
  hasNixSuffix = lib.hasSuffix ".nix";

  modules = builtins.concatLists [
    [
      # keep-sorted start case=no numeric=yes
      ./build-script.nix
      ./ros-0.nix
      ./ros-7.9.nix
      ./ros-example.nix
      # keep-sorted end
      (pkgs.path + "/nixos/modules/misc/assertions.nix")
      (pkgs.path + "/nixos/modules/misc/meta.nix")
      # Module deprecations and removals
      # ./deprecations.nix
    ]

    (
      if minimal then
        [ ]
      else
        lib.concatMap (
          dir:
          lib.pipe (builtins.readDir dir) [
            (lib.filterAttrs (path: kind: kind == "directory" || (kind == "regular" && hasNixSuffix path)))
            (lib.mapAttrsToList (path: _kind: lib.path.append dir path))
          ]
        ) [ ]
    )
  ];

  pkgsModule =
    { config, ... }:
    {
      config = {
        _module.args.baseModules = modules;
        _module.args.pkgsPath = lib.mkDefault (
          if lib.versionAtLeast config.home.stateVersion "20.09" then pkgs.path else <nixpkgs>
        );
        _module.args.pkgs = lib.mkDefault pkgs;
        _module.check = check;
        _module.args.lib = lib.ros;
      };
    };

in
modules ++ [ pkgsModule ]
