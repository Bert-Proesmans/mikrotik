{ lib, ... }:
let
  inherit (builtins)
    isBool
    isString
    isAttrs
    toString
    removeAttrs
    ;
  inherit (lib) filterAttrs mapAttrsToList concatStringsSep;
in
{
  toRosVal =
    val:
    if isBool val then
      (if val then "yes" else "no")
    else if isString val then
      "\"${val}\""
    else
      toString val;

  # Helper to build a property string: key="value"
  buildProps =
    attrs:
    let
      # Map our custom 'enable' to ROS 'disabled'
      mappedAttrs =
        if attrs ? enable && attrs.enable != null then
          (removeAttrs attrs [ "enable" ]) // { disabled = !attrs.enable; }
        else
          attrs;
      filtered = filterAttrs (k: v: v != null && k != "stub" && k != "name") mappedAttrs;
    in
    concatStringsSep " " (mapAttrsToList (k: v: "${k}=${toRosVal v}") filtered);

  # Core script generator
  # For each module path, loop over its attributes and emit ROS commands
  buildScript =
    cfg: path:
    if isAttrs cfg then
      concatStringsSep "\n" (
        mapAttrsToList (
          name: item:
          if item ? stub then
            if item.stub then
              "/${path} set [find name=\"${name}\"] ${buildProps item}"
            else
              "/${path} add name=\"${name}\" ${buildProps item}"
          else
            "/${path} set ${buildProps item}"
        ) cfg
      )
    else
      "";
}
