{ lib, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types)
    nullOr
    either
    str
    attrsOf
    listOf
    lines
    ;
  inherit (lib.ros.dag) dagOf entryAnywhere entryAfter;
in
{
  options.configVersion = mkOption {
    description = ''
      The RouterOS version you target while writing the configuration.
      This option is similar to NIxOS' stateVersion option.
    '';
    default = null;
    type = nullOr str;
  };

  options.taskOrder = mkOption {
    description = ''
      The order in which settings are applied to the target hardware.
      Data is the attribute path within the options to reach the specific CLI concept directory.
    '';
    default = { };
    type = (dagOf (listOf str));
  };

  options.userScripts = mkOption {
    description = ''
      Scripts executed at a certain point of the execution.
    '';
    default = { };
    type = (dagOf (lines));
  };

  config.taskOrder = {
    "system.identity" = [
      "system"
      "identity"
    ];
    "system.note" = entryAfter [ "system.identity" ] [ "system" "note" ];
  };
}
