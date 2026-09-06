{
  configuration,
  pkgs,
  lib ? pkgs.lib,
  minimal ? false,
  # Whether to check that each option has a matching declaration.
  check ? true,
  # Extra arguments passed to specialArgs.
  extraSpecialArgs ? { },
}:
let
  collectFailed = cfg: map (x: x.message) (lib.filter (x: !x.assertion) cfg.assertions);

  showWarnings =
    res:
    let
      f = w: x: builtins.trace "[1;31mwarning: ${w}[0m" x;
    in
    lib.foldr f res res.config.warnings;

  extendedLib = lib.extend (
    self: super:
    let
      rosLib = import ../lib { lib = self; };
    in
    {
      ros = rosLib;
    }
  );

  rosModules = import ./modules.nix {
    inherit check pkgs minimal;
    lib = extendedLib;
  };

  rawModule = extendedLib.evalModules {
    modules = [ configuration ] ++ rosModules;
    # modules = [ ] ++ rosModules;
    class = "ext-mikrotik";
    specialArgs = {
      modulesPath = toString ./.;
    }
    // extraSpecialArgs;
  };

  moduleChecks =
    raw:
    showWarnings (
      let
        failed = collectFailed raw.config;
        failedStr = lib.concatStringsSep "\n" (map (x: "- ${x}") failed);
      in
      if failed == [ ] then
        raw
      else
        throw ''

          Failed assertions:
          ${failedStr}''
    );

  withExtraAttrs =
    rawModule:
    let
      module = moduleChecks rawModule;
    in
    module
    // {
      extendModules = args: withExtraAttrs (rawModule.extendModules args);


      build.init-script = module.config.ros.script;
      build.update-script = module.config.ros.script;
    };
in
withExtraAttrs rawModule
