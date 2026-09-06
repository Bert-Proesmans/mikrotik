{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption;
  inherit (lib.types) submodule attrsOf str;
in
{
  options = {
    interface = mkOption {
      description = "";
      default = { };
      type = submodule {
        options = {
          bridge = mkOption {
            description = "";
            default = { };
            type = attrsOf submodule (
              { name, ... }: {
                options = {
                  name = mkOption {
                    description = "";
                    default = null;
                    type = str;
                  };
                  admin-mac = mkOption {
                    description = "";
                    default = null;
                    type = str;
                  };
                };
                config.name = name;
              }
            );
          };
        };
      };
    };
  };
}
