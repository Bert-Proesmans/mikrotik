{ config, lib, pkgs, ... }:

let
  unspecified = "_UNSPECIFIED_";

  # Helper to convert Nix values to RouterOS parameter strings
  toRosVal = val:
    if builtins.isBool val then (if val then "yes" else "no")
    else if builtins.isString val then "\"${val}\""
    else builtins.toString val;


  # Build a sequence of property strings: key="value"
  buildProps = attrs:
    let
      # Map our custom 'enable' backwards to ROS 'disabled'
      mappedAttrs =
        if attrs ? enable && attrs.enable != unspecified
        then (builtins.removeAttrs attrs ["enable"]) // { disabled = if attrs.enable == null then null else !attrs.enable; }
        else attrs;

      # Drop defaults/sentinels entirely
      filtered = lib.filterAttrs (k: v: v != unspecified && k != "stub" && k != "name") mappedAttrs;
    in
    lib.concatStringsSep " " (lib.mapAttrsToList (k: v:
      if v == null then "!${k}" # Explicit null maps to RouterOS unset syntax
      else "${k}=${toRosVal v}"
    ) filtered);


  # Core script generator
  buildScript = cfg: path:
    if builtins.isAttrs cfg then
      lib.concatStringsSep "\n" (lib.mapAttrsToList (name: item:
        let
          isStub = item ? stub && item.stub != unspecified && item.stub != null && item.stub;
        in
        if isStub
          then "/${path} set [find name=\"${name}\"] ${buildProps item}"
          else "/${path} add name=\"${name}\" ${buildProps item}"

      ) cfg)
    else "";


in {
  options = {
    aaa = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "called-format" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interim-update" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "mac-caching" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "mac-format" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "mac-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /caps-man/aaa";
    };

    access-list = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "action" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "allow-signal-out-of-range" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "ap-tx-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "client-to-client-forwarding" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "client-tx-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "mac-address-mask" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "private-passphrase" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "radius-accounting" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "signal-range" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ssid-regexp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0s..1d    (time interval)"; };
          "vlan-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vlan-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /caps-man/access-list";
    };

    actual-interface-configuration = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "arp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "channel.band" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "channel.control-channel-width" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "channel.extension-channel" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "channel.frequency" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "channel.reselect-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..42w6d    (time interval)"; };
          "channel.save-selected" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "channel.secondary-frequency" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "channel.skip-dfs-channels" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "channel.tx-power" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "configuration.country" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "configuration.disconnect-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0s..15s    (time interval)"; };
          "configuration.distance" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "configuration.frame-lifetime" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0s..15s    (time interval)"; };
          "configuration.guard-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "configuration.hide-ssid" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "configuration.hw-protection-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "configuration.hw-retries" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "configuration.installation" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "configuration.keepalive-frames" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "configuration.load-balancing-group" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "configuration.max-sta-count" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "configuration.mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "configuration.multicast-helper" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "configuration.rx-chains" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0|1|2|3[,ConfigurationRxChains*]"; };
          "configuration.ssid" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value, max length 32"; };
          "configuration.tx-chains" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0|1|2|3[,ConfigurationTxChains*]"; };
          "datapath.bridge" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "datapath.bridge-cost" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "datapath.bridge-horizon" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "datapath.client-to-client-forwarding" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "datapath.interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "datapath.local-forwarding" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "datapath.openflow-switch" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "datapath.vlan-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "datapath.vlan-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "disable-running-check" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "l2mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "master-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "radio-mac" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "security.authentication-types" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "wpa-psk|wpa2-psk|wpa-eap|wpa2-eap[,SecurityAuthenticationTypes*]"; };
          "security.disable-pmkid" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "security.eap-methods" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "security.eap-radius-accounting" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "security.encryption" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "aes-ccm|tkip[,SecurityEncryption*]"; };
          "security.group-encryption" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "security.group-key-update" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "30s..1d    (time interval)"; };
          "security.passphrase" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value, min length 8, max length 63"; };
          "security.tls-certificate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "security.tls-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /caps-man/actual-interface-configuration";
    };

    channel = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "band" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "control-channel-width" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "extension-channel" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "frequency" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "reselect-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..42w6d    (time interval)"; };
          "save-selected" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "secondary-frequency" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "skip-dfs-channels" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tx-power" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /caps-man/channel";
    };

    configuration = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "channel" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "channel.band" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "channel.control-channel-width" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "channel.extension-channel" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "channel.frequency" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "channel.reselect-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..42w6d    (time interval)"; };
          "channel.save-selected" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "channel.secondary-frequency" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "channel.skip-dfs-channels" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "channel.tx-power" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "country" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "datapath" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "datapath.arp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "datapath.bridge" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "datapath.bridge-cost" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "datapath.bridge-horizon" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "datapath.client-to-client-forwarding" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "datapath.interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "datapath.l2mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "datapath.local-forwarding" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "datapath.mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "datapath.openflow-switch" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "datapath.vlan-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "datapath.vlan-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "disconnect-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0s..15s    (time interval)"; };
          "distance" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "frame-lifetime" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0s..15s    (time interval)"; };
          "guard-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "hide-ssid" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "hw-protection-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "hw-retries" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "installation" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "keepalive-frames" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "load-balancing-group" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-sta-count" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "multicast-helper" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "rates" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "rates.basic" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1Mbps|2Mbps|5.5Mbps|11Mbps|6Mbps|9Mbps|12Mbps|18Mbps|24Mbps|36Mbps|48Mbps|54Mbps[,RatesBasic*]"; };
          "rates.ht-basic-mcs" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "mcs-0|mcs-1|mcs-2|mcs-3|mcs-4|mcs-5|mcs-6|mcs-7|mcs-8|mcs-9|mcs-10|mcs-11|mcs-12|mcs-13|mcs-14|mcs-15|mcs-16|mcs-17|mcs-18|mcs-19|mcs-20|mcs-21|mcs-22|mcs-23[,RatesHtBasicMcs*]"; };
          "rates.ht-supported-mcs" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "mcs-0|mcs-1|mcs-2|mcs-3|mcs-4|mcs-5|mcs-6|mcs-7|mcs-8|mcs-9|mcs-10|mcs-11|mcs-12|mcs-13|mcs-14|mcs-15|mcs-16|mcs-17|mcs-18|mcs-19|mcs-20|mcs-21|mcs-22|mcs-23[,RatesHtSupportedMcs*]"; };
          "rates.supported" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1Mbps|2Mbps|5.5Mbps|11Mbps|6Mbps|9Mbps|12Mbps|18Mbps|24Mbps|36Mbps|48Mbps|54Mbps[,RatesSupported*]"; };
          "rates.vht-basic-mcs" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "rates.vht-supported-mcs" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "rx-chains" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0|1|2|3[,RxChains*]"; };
          "security" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "security.authentication-types" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "wpa-psk|wpa2-psk|wpa-eap|wpa2-eap[,SecurityAuthenticationTypes*]"; };
          "security.disable-pmkid" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "security.eap-methods" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "security.eap-radius-accounting" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "security.encryption" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "aes-ccm|tkip[,SecurityEncryption*]"; };
          "security.group-encryption" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "security.group-key-update" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "30s..1d    (time interval)"; };
          "security.passphrase" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value, min length 8, max length 63"; };
          "security.tls-certificate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "security.tls-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ssid" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value, max length 32"; };
          "tx-chains" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0|1|2|3[,TxChains*]"; };
        };
      });
      default = {};
      description = "Configuration for /caps-man/configuration";
    };

    datapath = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "arp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "bridge" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "bridge-cost" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "bridge-horizon" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "client-to-client-forwarding" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "l2mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "local-forwarding" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "openflow-switch" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vlan-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vlan-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /caps-man/datapath";
    };

    interface = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "arp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "channel" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "channel.band" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "channel.control-channel-width" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "channel.extension-channel" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "channel.frequency" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "channel.reselect-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..42w6d    (time interval)"; };
          "channel.save-selected" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "channel.secondary-frequency" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "channel.skip-dfs-channels" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "channel.tx-power" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "configuration" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "configuration.country" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "configuration.disconnect-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0s..15s    (time interval)"; };
          "configuration.distance" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "configuration.frame-lifetime" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0s..15s    (time interval)"; };
          "configuration.guard-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "configuration.hide-ssid" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "configuration.hw-protection-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "configuration.hw-retries" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "configuration.installation" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "configuration.keepalive-frames" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "configuration.load-balancing-group" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "configuration.max-sta-count" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "configuration.mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "configuration.multicast-helper" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "configuration.rx-chains" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0|1|2|3[,ConfigurationRxChains*]"; };
          "configuration.ssid" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value, max length 32"; };
          "configuration.tx-chains" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0|1|2|3[,ConfigurationTxChains*]"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "datapath" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "datapath.bridge" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "datapath.bridge-cost" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "datapath.bridge-horizon" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "datapath.client-to-client-forwarding" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "datapath.interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "datapath.local-forwarding" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "datapath.openflow-switch" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "datapath.vlan-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "datapath.vlan-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "disable-running-check" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "l2mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "master-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "radio-mac" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "radio-name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "rates" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "rates.basic" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1Mbps|2Mbps|5.5Mbps|11Mbps|6Mbps|9Mbps|12Mbps|18Mbps|24Mbps|36Mbps|48Mbps|54Mbps[,RatesBasic*]"; };
          "rates.ht-basic-mcs" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "mcs-0|mcs-1|mcs-2|mcs-3|mcs-4|mcs-5|mcs-6|mcs-7|mcs-8|mcs-9|mcs-10|mcs-11|mcs-12|mcs-13|mcs-14|mcs-15|mcs-16|mcs-17|mcs-18|mcs-19|mcs-20|mcs-21|mcs-22|mcs-23[,RatesHtBasicMcs*]"; };
          "rates.ht-supported-mcs" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "mcs-0|mcs-1|mcs-2|mcs-3|mcs-4|mcs-5|mcs-6|mcs-7|mcs-8|mcs-9|mcs-10|mcs-11|mcs-12|mcs-13|mcs-14|mcs-15|mcs-16|mcs-17|mcs-18|mcs-19|mcs-20|mcs-21|mcs-22|mcs-23[,RatesHtSupportedMcs*]"; };
          "rates.supported" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1Mbps|2Mbps|5.5Mbps|11Mbps|6Mbps|9Mbps|12Mbps|18Mbps|24Mbps|36Mbps|48Mbps|54Mbps[,RatesSupported*]"; };
          "rates.vht-basic-mcs" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "rates.vht-supported-mcs" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "security" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "security.authentication-types" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "wpa-psk|wpa2-psk|wpa-eap|wpa2-eap[,SecurityAuthenticationTypes*]"; };
          "security.disable-pmkid" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "security.eap-methods" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "security.eap-radius-accounting" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "security.encryption" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "aes-ccm|tkip[,SecurityEncryption*]"; };
          "security.group-encryption" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "security.group-key-update" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "30s..1d    (time interval)"; };
          "security.passphrase" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value, min length 8, max length 63"; };
          "security.tls-certificate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "security.tls-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /caps-man/interface";
    };

    manager = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "ca-certificate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "certificate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "enabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "package-path" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "require-peer-certificate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "upgrade-policy" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /caps-man/manager";
    };

    interface = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "forbid" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /caps-man/manager/interface";
    };

    provisioning = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "action" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "common-name-regexp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "hw-supported-modes" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "identity-regexp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "ip-address-ranges" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D[-A.B.C.D |0..32 |/A.B.C.D ]    (IP address range)"; };
          "master-configuration" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name-format" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name-prefix" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "radio-mac" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "slave-configurations" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /caps-man/provisioning";
    };

    rates = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "basic" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1Mbps|2Mbps|5.5Mbps|11Mbps|6Mbps|9Mbps|12Mbps|18Mbps|24Mbps|36Mbps|48Mbps|54Mbps[,Basic*]"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ht-basic-mcs" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "mcs-0|mcs-1|mcs-2|mcs-3|mcs-4|mcs-5|mcs-6|mcs-7|mcs-8|mcs-9|mcs-10|mcs-11|mcs-12|mcs-13|mcs-14|mcs-15|mcs-16|mcs-17|mcs-18|mcs-19|mcs-20|mcs-21|mcs-22|mcs-23[,HtBasicMcs*]"; };
          "ht-supported-mcs" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "mcs-0|mcs-1|mcs-2|mcs-3|mcs-4|mcs-5|mcs-6|mcs-7|mcs-8|mcs-9|mcs-10|mcs-11|mcs-12|mcs-13|mcs-14|mcs-15|mcs-16|mcs-17|mcs-18|mcs-19|mcs-20|mcs-21|mcs-22|mcs-23[,HtSupportedMcs*]"; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "supported" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1Mbps|2Mbps|5.5Mbps|11Mbps|6Mbps|9Mbps|12Mbps|18Mbps|24Mbps|36Mbps|48Mbps|54Mbps[,Supported*]"; };
          "vht-basic-mcs" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vht-supported-mcs" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /caps-man/rates";
    };

    security = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "authentication-types" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "wpa-psk|wpa2-psk|wpa-eap|wpa2-eap[,AuthenticationTypes*]"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "disable-pmkid" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "eap-methods" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "eap-radius-accounting" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "encryption" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "aes-ccm|tkip[,Encryption*]"; };
          "group-encryption" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "group-key-update" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "30s..1d    (time interval)"; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "passphrase" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value, min length 8, max length 63"; };
          "tls-certificate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tls-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /caps-man/security";
    };

    certificate = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "common-name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "country" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "days-valid" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "digest-algorithm" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "key-size" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "key-usage" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "digital-signature|content-commitment|key-encipherment|data-encipherment|key-agreement|key-cert-sign|crl-sign|encipher-only|decipher-only|tls-server|tls-client|code-sign|email-protect|timestamp|ocsp-sign[,KeyUsage*]"; };
          "locality" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "organization" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "state" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "subject-alt-name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "trusted" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "unit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /certificate";
    };

    crl = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "url" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /certificate/crl";
    };

    scep-server = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "ca-cert" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "days-valid" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "next-ca-cert" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "path" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "request-lifetime" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "5m..    (time interval)"; };
        };
      });
      default = {};
      description = "Configuration for /certificate/scep-server";
    };

    ra = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "ca-identity" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "challenge-password" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "fingerprint-algorithm" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "on-smart-card" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ra-path" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "ra-transaction-lifetime" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "5m..    (time interval)"; };
          "server-url" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "template" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /certificate/scep-server/ra";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "crl-download" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "crl-store" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "crl-use" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /certificate/settings";
    };

    disk = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "parent" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "partition-number" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "partition-offset" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "partition-size" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "slot" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value, max length 32"; };
          "tmpfs-max-size" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /disk";
    };

    file = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "contents" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /file";
    };

    interface = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "l2mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      };
      default = {};
      description = "Configuration for /interface";
    };

    6to4 = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "clamp-tcp-mss" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dont-fragment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dscp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ipsec-secret" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "keepalive" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..    (time interval)"; };
          "local-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "remote-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "unspecified | A.B.C.D    (IP address)"; };
        };
      });
      default = {};
      description = "Configuration for /interface/6to4";
    };

    bonding = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "arp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "arp-ip-targets" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "arp-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "down-delay" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "forced-mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "lacp-rate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "lacp-user-key" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "link-monitoring" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mii-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "min-links" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mlag-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "primary" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "slaves" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "transmit-hash-policy" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "up-delay" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
        };
      });
      default = {};
      description = "Configuration for /interface/bonding";
    };

    bridge = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "add-dhcp-option82" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "admin-mac" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "ageing-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "10s..1w4d13h46m40s    (time interval)"; };
          "arp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "auto-mac" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dhcp-snooping" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "ether-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "fast-forward" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "forward-delay" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "4s..30s    (time interval)"; };
          "frame-types" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "igmp-snooping" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "igmp-version" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ingress-filtering" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "last-member-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..    (time interval)"; };
          "last-member-query-count" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-hops" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-message-age" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "6s..40s    (time interval)"; };
          "membership-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..    (time interval)"; };
          "mld-version" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "multicast-querier" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "multicast-router" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "protocol-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "pvid" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "querier-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..    (time interval)"; };
          "query-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..    (time interval)"; };
          "query-response-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..    (time interval)"; };
          "region-name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "region-revision" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "startup-query-count" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "startup-query-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..    (time interval)"; };
          "transmit-hold-count" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vlan-filtering" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /interface/bridge";
    };

    calea = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "802.3-sap" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "802.3-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "action" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-dst-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-dst-mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-gratuitous" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-hardware-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-opcode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-packet-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-src-mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "chain" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address6" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-bridge" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-bridge-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ingress-priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ip-protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "log" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "log-prefix" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "mac-protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-bridge" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-bridge-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "packet-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "packet-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "sniff-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "sniff-target" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "sniff-target-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address6" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-flags" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-forward-delay" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-hello-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-max-age" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-msg-age" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-root-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-root-cost" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-root-priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-sender-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-sender-priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tls-host" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vlan-encap" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vlan-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vlan-priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /interface/bridge/calea";
    };

    filter = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "802.3-sap" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "802.3-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "action" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-dst-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-dst-mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-gratuitous" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-hardware-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-opcode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-packet-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-src-mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "chain" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address6" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-bridge" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-bridge-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ingress-priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ip-protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "jump-target" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "log" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "log-prefix" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "mac-protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "new-packet-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "new-priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-bridge" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-bridge-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "packet-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "packet-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "passthrough" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address6" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-flags" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-forward-delay" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-hello-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-max-age" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-msg-age" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-root-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-root-cost" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-root-priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-sender-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-sender-priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tls-host" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vlan-encap" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vlan-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vlan-priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /interface/bridge/filter";
    };

    host = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "bridge" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "vid" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /interface/bridge/host";
    };

    mdb = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "bridge" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "group" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "ports" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vid" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /interface/bridge/mdb";
    };

    msti = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "bridge" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "identifier" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vlan-mapping" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /interface/bridge/msti";
    };

    nat = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "802.3-sap" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "802.3-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "action" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-dst-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-dst-mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-gratuitous" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-hardware-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-opcode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-packet-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-src-mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "chain" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address6" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-bridge" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-bridge-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ingress-priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ip-protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "jump-target" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "log" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "log-prefix" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "mac-protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "new-packet-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "new-priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-bridge" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-bridge-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "packet-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "packet-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "passthrough" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address6" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-flags" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-forward-delay" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-hello-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-max-age" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-msg-age" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-root-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-root-cost" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-root-priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-sender-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-sender-priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stp-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tls-host" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "to-arp-reply-mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "to-dst-mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "to-src-mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "vlan-encap" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vlan-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vlan-priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /interface/bridge/nat";
    };

    port = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "auto-isolate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "bpdu-guard" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "bridge" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "broadcast-flood" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "edge" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "fast-leave" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "frame-types" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "horizon" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "hw" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ingress-filtering" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "internal-path-cost" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "learn" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "multicast-router" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "path-cost" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "point-to-point" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "pvid" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "restricted-role" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "restricted-tcn" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tag-stacking" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "trusted" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "unknown-multicast-flood" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "unknown-unicast-flood" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /interface/bridge/port";
    };

    mst-override = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "identifier" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "internal-path-cost" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /interface/bridge/port/mst-override";
    };

    port-controller = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "bridge" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "cascade-ports" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "switch" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /interface/bridge/port-controller";
    };

    device = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /interface/bridge/port-controller/device";
    };

    port = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      };
      default = {};
      description = "Configuration for /interface/bridge/port-controller/port";
    };

    port-extender = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "control-ports" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "excluded-ports" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "switch" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /interface/bridge/port-extender";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "allow-fast-path" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "use-ip-firewall" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "use-ip-firewall-for-pppoe" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "use-ip-firewall-for-vlan" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /interface/bridge/settings";
    };

    vlan = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "bridge" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "tagged" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "untagged" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vlan-ids" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /interface/bridge/vlan";
    };

    detect-internet = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "detect-interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "internet-interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "lan-interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "wan-interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /interface/detect-internet";
    };

    client = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "anon-identity" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "certificate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "eap-methods" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "identity" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "password" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /interface/dot1x/client";
    };

    server = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "accounting" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "auth-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "100ms..    (time interval)"; };
          "auth-types" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "dot1x|mac-auth[,AuthTypes*]"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "guest-vlan-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interim-update" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "mac-auth-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "radius-mac-format" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "reauth-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..    (time interval)"; };
          "reject-vlan-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "retrans-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "100ms..    (time interval)"; };
          "server-fail-vlan-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /interface/dot1x/server";
    };

    active = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /interface/dot1x/server/active";
    };

    eoip = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "allow-fast-path" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "clamp-tcp-mss" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dont-fragment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dscp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ipsec-secret" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "keepalive" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..    (time interval)"; };
          "local-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "loop-protect" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "loop-protect-disable-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "loop-protect-send-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..    (time interval)"; };
          "mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "remote-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "tunnel-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /interface/eoip";
    };

    eoipv6 = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "arp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "clamp-tcp-mss" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dscp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ipsec-secret" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "keepalive" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..    (time interval)"; };
          "local-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "loop-protect" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "loop-protect-disable-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "loop-protect-send-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..    (time interval)"; };
          "mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "remote-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "tunnel-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /interface/eoipv6";
    };

    ethernet = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "advertise" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "auto-negotiation" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "cable-settings" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "combo-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "disable-running-check" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "fec-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "full-duplex" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "l2mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "loop-protect" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "loop-protect-disable-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "loop-protect-send-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..    (time interval)"; };
          "mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "mdix-enable" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "orig-mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "rx-flow-control" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "sfp-rate-select" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "sfp-shutdown-temperature" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "speed" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tx-flow-control" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /interface/ethernet";
    };

    gre = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "allow-fast-path" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "clamp-tcp-mss" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dont-fragment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dscp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ipsec-secret" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "keepalive" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..    (time interval)"; };
          "local-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "remote-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
        };
      });
      default = {};
      description = "Configuration for /interface/gre";
    };

    gre6 = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "clamp-tcp-mss" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dscp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ipsec-secret" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "keepalive" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..    (time interval)"; };
          "local-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "remote-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
        };
      });
      default = {};
      description = "Configuration for /interface/gre6";
    };

    ipip = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "allow-fast-path" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "clamp-tcp-mss" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dont-fragment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dscp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ipsec-secret" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "keepalive" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..    (time interval)"; };
          "local-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "remote-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
        };
      });
      default = {};
      description = "Configuration for /interface/ipip";
    };

    ipipv6 = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "clamp-tcp-mss" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dscp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ipsec-secret" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "keepalive" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..    (time interval)"; };
          "local-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "remote-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
        };
      });
      default = {};
      description = "Configuration for /interface/ipipv6";
    };

    l2tp-client = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "add-default-route" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "allow" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "pap|chap|mschap1|mschap2[,Allow*]"; };
          "allow-fast-path" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "connect-to" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "default-route-distance" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dial-on-demand" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "ipsec-secret" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "keepalive-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "l2tp-proto-version" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "l2tpv3-circuit-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "l2tpv3-cookie-length" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "l2tpv3-digest-hash" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-mru" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mrru" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "password" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "profile" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "use-ipsec" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "use-peer-dns" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "user" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /interface/l2tp-client";
    };

    l2tp-ether = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "allow-fast-path" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "circuit-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "connect-to" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "cookie-length" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "digest-hash" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "ipsec-secret" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "l2tp-proto-version" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "local-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "local-session-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "local-tunnel-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "peer-cookie" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value, max length 16"; };
          "remote-session-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "remote-tunnel-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "send-cookie" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value, max length 16"; };
          "unmanaged-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "use-ipsec" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "use-l2-specific-sublayer" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /interface/l2tp-ether";
    };

    l2tp-server = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "user" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /interface/l2tp-server";
    };

    server = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "accept-proto-version" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "accept-pseudowire-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "allow-fast-path" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "authentication" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "pap|chap|mschap1|mschap2[,Authentication*]"; };
          "caller-id-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "default-profile" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "enabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ipsec-secret" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "keepalive-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "l2tpv3-circuit-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "l2tpv3-cookie-length" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "l2tpv3-digest-hash" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "l2tpv3-ether-interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-mru" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-sessions" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mrru" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "one-session-per-host" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "use-ipsec" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /interface/l2tp-server/server";
    };

    list = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "exclude" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "include" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /interface/list";
    };

    member = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /interface/list/member";
    };

    lte = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "allow-roaming" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "apn-profiles" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "band" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "master" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "modem-init" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "network-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "nr-band" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "operator" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "pin" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      };
      default = {};
      description = "Configuration for /interface/lte";
    };

    apn = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "add-default-route" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "apn" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "authentication" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "default-route-distance" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ip-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ipv6-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "passthrough-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "passthrough-mac" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "passthrough-subnet-selection" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "password" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "use-network-apn" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "use-peer-dns" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "user" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /interface/lte/apn";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "firmware-path" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /interface/lte/settings";
    };

    macsec = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "cak" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value, max length 16"; };
          "ckn" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value, max length 32"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "profile" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /interface/macsec";
    };

    profile = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "server-priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /interface/macsec/profile";
    };

    mesh = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "admin-mac" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "arp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "auto-mac" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "hwmp-default-hoplimit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "hwmp-prep-lifetime" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "..1h    (time interval)"; };
          "hwmp-preq-destination-only" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "hwmp-preq-reply-and-forward" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "hwmp-preq-retries" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "hwmp-preq-waiting-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..30s    (time interval)"; };
          "hwmp-rann-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "..30m    (time interval)"; };
          "hwmp-rann-lifetime" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "..1h    (time interval)"; };
          "hwmp-rann-propagation-delay" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mesh-portal" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "reoptimize-paths" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /interface/mesh";
    };

    port = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "hello-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..1m    (time interval)"; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mesh" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "path-cost" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "port-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /interface/mesh/port";
    };

    ovpn-client = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "add-default-route" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "auth" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "certificate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "cipher" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "connect-to" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "disconnect-notify" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "max-mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "password" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "profile" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "route-nopull" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tls-version" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "use-peer-dns" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "user" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "verify-server-certificate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /interface/ovpn-client";
    };

    ovpn-server = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "user" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /interface/ovpn-server";
    };

    server = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "auth" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "sha1|md5|sha256|sha512|null[,Auth*]"; };
          "certificate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "cipher" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "blowfish128|aes128-cbc|aes192-cbc|aes256-cbc|aes128-gcm|aes192-gcm|aes256-gcm|null[,Cipher*]"; };
          "default-profile" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "enable-tun-ipv6" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "enabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ipv6-prefix-len" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "keepalive-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "max-mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "netmask" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "redirect-gateway" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "disabled|def1|ipv6[,RedirectGateway*]"; };
          "reneg-sec" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "require-client-certificate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tls-version" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tun-server-ipv6" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
        };
      };
      default = {};
      description = "Configuration for /interface/ovpn-server/server";
    };

    ppp-client = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "add-default-route" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "allow" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "pap|chap|mschap1|mschap2[,Allow*]"; };
          "apn" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "data-channel" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "default-route-distance" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dial-command" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "dial-on-demand" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "info-channel" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "keepalive-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-mru" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "modem-init" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "mrru" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "null-modem" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "password" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "phone" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "pin" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "profile" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "remote-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "use-peer-dns" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "user" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /interface/ppp-client";
    };

    ppp-server = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "authentication" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "pap|chap|mschap1|mschap2[,Authentication*]"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "data-channel" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "max-mru" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "modem-init" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "mrru" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "null-modem" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "profile" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ring-count" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /interface/ppp-server";
    };

    pppoe-client = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "ac-name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "add-default-route" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "allow" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "pap|chap|mschap1|mschap2[,Allow*]"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "default-route-distance" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dial-on-demand" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "host-uniq" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "keepalive-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-mru" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mrru" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "password" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "profile" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "service-name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "use-peer-dns" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "user" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /interface/pppoe-client";
    };

    pppoe-server = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "service" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "user" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /interface/pppoe-server";
    };

    server = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "accept-empty-service" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "authentication" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "pap|chap|mschap1|mschap2[,Authentication*]"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "default-profile" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "keepalive-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-mru" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-sessions" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mrru" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "one-session-per-host" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "pado-delay" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "service-name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /interface/pppoe-server/server";
    };

    pptp-client = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "add-default-route" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "allow" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "pap|chap|mschap1|mschap2[,Allow*]"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "connect-to" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "default-route-distance" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dial-on-demand" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "keepalive-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-mru" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mrru" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "password" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "profile" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "use-peer-dns" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "user" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /interface/pptp-client";
    };

    pptp-server = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "user" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /interface/pptp-server";
    };

    server = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "authentication" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "pap|chap|mschap1|mschap2[,Authentication*]"; };
          "default-profile" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "enabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "keepalive-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-mru" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mrru" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /interface/pptp-server/server";
    };

    sstp-client = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "add-default-route" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "authentication" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "pap|chap|mschap1|mschap2[,Authentication*]"; };
          "certificate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "connect-to" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "default-route-distance" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dial-on-demand" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "http-proxy" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "keepalive-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-mru" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mrru" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "password" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "pfs" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "profile" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "proxy-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tls-version" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "user" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "verify-server-address-from-certificate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "verify-server-certificate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /interface/sstp-client";
    };

    sstp-server = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "user" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /interface/sstp-server";
    };

    server = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "authentication" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "pap|chap|mschap1|mschap2[,Authentication*]"; };
          "certificate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "default-profile" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "enabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "keepalive-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-mru" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mrru" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "pfs" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tls-version" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "verify-client-certificate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /interface/sstp-server/server";
    };

    veth = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "gateway" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /interface/veth";
    };

    vlan = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "arp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "loop-protect" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "loop-protect-disable-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "loop-protect-send-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..    (time interval)"; };
          "mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "use-service-tag" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vlan-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /interface/vlan";
    };

    vpls = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "arp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "bridge" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "bridge-cost" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "bridge-horizon" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "cisco-static-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "disable-running-check" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "peer" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "pw-control-word" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "pw-l2mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "pw-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vpls-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
        };
      });
      default = {};
      description = "Configuration for /interface/vpls";
    };

    vrrp = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "arp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "authentication" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "group-master" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "10ms..4m15s    (time interval)"; };
          "mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "on-backup" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "on-fail" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "on-master" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "password" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value, max length 16"; };
          "preemption-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "remote-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "sync-connection-tracking" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "v3-protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "version" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vrid" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /interface/vrrp";
    };

    vxlan = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "allow-fast-path" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dont-fragment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "group" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "local-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "loop-protect" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "loop-protect-disable-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "loop-protect-send-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..    (time interval)"; };
          "mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "max-fdb-size" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vni" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vrf" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vteps-ip-version" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /interface/vxlan";
    };

    vteps = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "remote-ip" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
        };
      });
      default = {};
      description = "Configuration for /interface/vxlan/vteps";
    };

    wireguard = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "listen-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "private-key" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /interface/wireguard";
    };

    peers = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "allowed-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "endpoint-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "endpoint-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "persistent-keepalive" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0s..18h12m15s    (time interval)"; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "preshared-key" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "public-key" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /interface/wireguard/peers";
    };

    wireless = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "adaptive-noise-immunity" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "allow-sharedkey" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ampdu-priorities" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0|1|2|3|4|5|6|7[,AmpduPriorities*]"; };
          "amsdu-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "amsdu-threshold" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "antenna-gain" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "antenna-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "area" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "arp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "band" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "basic-rates-a/g" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "6Mbps|9Mbps|12Mbps|18Mbps|24Mbps|36Mbps|48Mbps|54Mbps[,BasicRatesAG*]"; };
          "basic-rates-b" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1Mbps|2Mbps|5.5Mbps|11Mbps[,BasicRatesB*]"; };
          "bridge-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "burst-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "channel-width" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "compression" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "country" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "default-ap-tx-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "default-authentication" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "default-client-tx-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "default-forwarding" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "disable-running-check" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "disconnect-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0s..15s    (time interval)"; };
          "distance" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "frame-lifetime" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "frequency" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "frequency-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "frequency-offset" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "guard-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "hide-ssid" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ht-basic-mcs" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "mcs-0|mcs-1|mcs-2|mcs-3|mcs-4|mcs-5|mcs-6|mcs-7|mcs-8|mcs-9|mcs-10|mcs-11|mcs-12|mcs-13|mcs-14|mcs-15|mcs-16|mcs-17|mcs-18|mcs-19|mcs-20|mcs-21|mcs-22|mcs-23|mcs-24|mcs-25|mcs-26|mcs-27|mcs-28|mcs-29|mcs-30|mcs-31[,HtBasicMcs*]"; };
          "ht-supported-mcs" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "mcs-0|mcs-1|mcs-2|mcs-3|mcs-4|mcs-5|mcs-6|mcs-7|mcs-8|mcs-9|mcs-10|mcs-11|mcs-12|mcs-13|mcs-14|mcs-15|mcs-16|mcs-17|mcs-18|mcs-19|mcs-20|mcs-21|mcs-22|mcs-23|mcs-24|mcs-25|mcs-26|mcs-27|mcs-28|mcs-29|mcs-30|mcs-31[,HtSupportedMcs*]"; };
          "hw-fragmentation-threshold" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "hw-protection-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "hw-protection-threshold" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "hw-retries" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "installation" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interworking-profile" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "keepalive-frames" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "l2mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "master-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-station-count" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "multicast-buffering" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "multicast-helper" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "noise-floor-threshold" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "nv2-cell-radius" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "nv2-downlink-ratio" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "nv2-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "nv2-noise-floor-offset" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "nv2-preshared-key" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "nv2-qos" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "nv2-queue-count" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "nv2-security" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "nv2-sync-secret" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value, max length 32"; };
          "on-fail-retry-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "100ms..1s    (time interval)"; };
          "preamble-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "prism-cardtype" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "radio-name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "rate-selection" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "rate-set" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "rx-chains" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0|1|2|3[,RxChains*]"; };
          "scan-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "secondary-frequency" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "security-profile" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "skip-dfs-channels" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ssid" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "station-bridge-clone-mac" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "station-roaming" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "supported-rates-a/g" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "6Mbps|9Mbps|12Mbps|18Mbps|24Mbps|36Mbps|48Mbps|54Mbps[,SupportedRatesAG*]"; };
          "supported-rates-b" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1Mbps|2Mbps|5.5Mbps|11Mbps[,SupportedRatesB*]"; };
          "tdma-period-size" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tx-chains" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0|1|2|3[,TxChains*]"; };
          "tx-power" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tx-power-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "update-stats-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "10s..5h    (time interval)"; };
          "vht-basic-mcs" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vht-supported-mcs" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vlan-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vlan-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "wds-cost-range" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "wds-default-bridge" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "wds-default-cost" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "wds-ignore-ssid" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "wds-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "wireless-protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "wmm-support" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "wps-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /interface/wireless";
    };

    access-list = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "allow-signal-out-of-range" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "ap-tx-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "authentication" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "client-tx-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "forwarding" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "management-protection-key" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "private-algo" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "private-key" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "private-pre-shared-key" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "signal-range" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0s..1d    (time interval)"; };
          "vlan-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vlan-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /interface/wireless/access-list";
    };

    align = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "active-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "audio-max" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "audio-min" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "audio-monitor" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "filter-mac" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "frame-size" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "frames-per-second" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "receive-all" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ssid-all" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /interface/wireless/align";
    };

    cap = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "bridge" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "caps-man-addresses" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "caps-man-certificate-common-names" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value, min length 1"; };
          "caps-man-names" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value, min length 1"; };
          "certificate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "discovery-interfaces" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "enabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interfaces" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "lock-to-caps-man" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "static-virtual" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /interface/wireless/cap";
    };

    channels = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "band" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "extension-channel" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "frequency" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "width" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /interface/wireless/channels";
    };

    connect-list = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "3gpp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "allow-signal-out-of-range" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "area-prefix" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "connect" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interworking" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "iw-asra" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "iw-authentication-types" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "iw-connection-capabilities" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "iw-esr" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "iw-hessid" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "iw-hotspot20" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "iw-hotspot20-dgaf" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "iw-internet" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "iw-ipv4-availability" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "iw-ipv6-availability" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "iw-network-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "iw-realms" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "iw-roaming-ois" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "iw-uesa" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "iw-venue" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "security-profile" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "signal-range" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ssid" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "wireless-protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /interface/wireless/connect-list";
    };

    interworking-profiles = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "3gpp-info" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value, min length 3, max length 3"; };
          "3gpp-raw" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "asra" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "authentication-types" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "connection-capabilities" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "domain-names" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "esr" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "hessid" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "hotspot20" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "hotspot20-dgaf" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "internet" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ipv4-availability" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ipv6-availability" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "network-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "operational-classes" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "operator-names" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "realms" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "realms-raw" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "roaming-ois" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "uesa" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "venue" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "venue-names" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "wan-at-capacity" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "wan-downlink" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "wan-downlink-load" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "wan-measurement-duration" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "wan-status" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "wan-symmetric" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "wan-uplink" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "wan-uplink-load" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /interface/wireless/interworking-profiles";
    };

    manual-tx-power-table = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "manual-tx-powers" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /interface/wireless/manual-tx-power-table";
    };

    nstreme = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "disable-csma" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "enable-nstreme" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "enable-polling" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "framer-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "framer-policy" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /interface/wireless/nstreme";
    };

    nstreme-dual = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "arp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "disable-csma" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "disable-running-check" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "framer-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "framer-policy" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ht-channel-width" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ht-guard-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ht-rates" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1|2|3|4|5|6|7|8[,HtRates*]"; };
          "ht-streams" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "l2mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "rates-a/g" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "6Mbps|9Mbps|12Mbps|18Mbps|24Mbps|36Mbps|48Mbps|54Mbps[,RatesAG*]"; };
          "rates-b" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1Mbps|2Mbps|5.5Mbps|11Mbps[,RatesB*]"; };
          "remote-mac" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "rx-band" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "rx-channel-width" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "rx-frequency" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "rx-radio" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tx-band" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tx-channel-width" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tx-frequency" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tx-radio" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /interface/wireless/nstreme-dual";
    };

    security-profiles = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "authentication-types" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "wpa-psk|wpa2-psk|wpa-eap|wpa2-eap[,AuthenticationTypes*]"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "disable-pmkid" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "eap-methods" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "group-ciphers" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "tkip|aes-ccm[,GroupCiphers*]"; };
          "group-key-update" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "30s..1d    (time interval)"; };
          "interim-update" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "management-protection" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "management-protection-key" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mschapv2-password" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "mschapv2-username" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "radius-called-format" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "radius-eap-accounting" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "radius-mac-accounting" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "radius-mac-authentication" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "radius-mac-caching" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "radius-mac-format" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "radius-mac-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "static-algo-0" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "static-algo-1" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "static-algo-2" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "static-algo-3" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "static-key-0" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "static-key-1" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "static-key-2" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "static-key-3" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "static-sta-private-algo" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "static-sta-private-key" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "static-transmit-key" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "supplicant-identity" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "tls-certificate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tls-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "unicast-ciphers" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "tkip|aes-ccm[,UnicastCiphers*]"; };
          "wpa-pre-shared-key" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "wpa2-pre-shared-key" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /interface/wireless/security-profiles";
    };

    sniffer = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "channel-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "file-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "file-name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "memory-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "multiple-channels" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "only-headers" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "receive-errors" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "streaming-enabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "streaming-max-rate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "streaming-server" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
        };
      };
      default = {};
      description = "Configuration for /interface/wireless/sniffer";
    };

    snooper = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "channel-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "multiple-channels" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "receive-errors" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /interface/wireless/snooper";
    };

    wds = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "arp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "disable-running-check" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "l2mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "master-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "wds-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
        };
      });
      default = {};
      description = "Configuration for /interface/wireless/wds";
    };

    address = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "broadcast" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "netmask" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "network" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
        };
      });
      default = {};
      description = "Configuration for /ip/address";
    };

    arp = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "published" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/arp";
    };

    cloud = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "ddns-enabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ddns-update-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1m..    (time interval)"; };
          "update-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /ip/cloud";
    };

    advanced = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "use-local-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /ip/cloud/advanced";
    };

    dhcp-client = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "add-default-route" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "default-route-distance" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dhcp-options" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "script" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "use-peer-dns" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "use-peer-ntp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/dhcp-client";
    };

    option = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "code" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "value" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /ip/dhcp-client/option";
    };

    dhcp-relay = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "add-relay-info" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "delay-threshold" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "dhcp-server" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "local-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "relay-info-remote-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /ip/dhcp-relay";
    };

    dhcp-server = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "add-arp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "address-pool" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "allow-dual-stack-queue" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "always-broadcast" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "authoritative" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "bootp-lease-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "bootp-support" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "client-mac-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "conflict-detection" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "delay-threshold" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "dhcp-option-set" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "insert-queue-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "lease-script" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "lease-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..    (time interval)"; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "parent-queue" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "relay" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "server-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "use-framed-as-classless" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "use-radius" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/dhcp-server";
    };

    alert = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "alert-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "on-alert" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "valid-server" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
        };
      });
      default = {};
      description = "Configuration for /ip/dhcp-server/alert";
    };

    config = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "accounting" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interim-update" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "radius-password" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value, min length 1"; };
          "store-leases-disk" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
        };
      };
      default = {};
      description = "Configuration for /ip/dhcp-server/config";
    };

    lease = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "address-lists" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "allow-dual-stack-queue" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "always-broadcast" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "block-access" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "client-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dhcp-option" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dhcp-option-set" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "insert-queue-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "lease-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "parent-queue" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "queue-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "rate-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "routes" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "server" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "use-src-mac" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/dhcp-server/lease";
    };

    matcher = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "address-pool" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "code" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "option-set" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "server" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "value" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value, min length 1, max length 510"; };
        };
      });
      default = {};
      description = "Configuration for /ip/dhcp-server/matcher";
    };

    network = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "boot-file-name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "caps-manager" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dhcp-option" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dhcp-option-set" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dns-none" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dns-server" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "domain" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "gateway" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "netmask" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "next-server" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "ntp-server" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "wins-server" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
        };
      });
      default = {};
      description = "Configuration for /ip/dhcp-server/network";
    };

    option = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "code" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "force" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "value" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /ip/dhcp-server/option";
    };

    sets = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "options" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/dhcp-server/option/sets";
    };

    dns = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "allow-remote-requests" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "cache-max-ttl" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "cache-size" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "doh-max-concurrent-queries" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "doh-max-server-connections" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "doh-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "max-concurrent-queries" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-concurrent-tcp-sessions" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-udp-packet-size" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "query-server-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "query-total-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "servers" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "use-doh-server" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "verify-doh-cert" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /ip/dns";
    };

    static = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "address-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "cname" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "forward-to" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "match-subdomain" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mx-exchange" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "mx-preference" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "ns" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "regexp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "srv-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "srv-priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "srv-target" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "srv-weight" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "text" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "ttl" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/dns/static";
    };

    address-list = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D[-A.B.C.D |0..32 |/A.B.C.D ]    (IP address range)"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dynamic" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "..35w3d13h13m56s    (time interval)"; };
        };
      });
      default = {};
      description = "Configuration for /ip/firewall/address-list";
    };

    calea = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "action" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "address-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "address-list-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "..35w3d13h13m56s    (time interval)"; };
          "chain" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "connection-bytes" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-rate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "content" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dscp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "fragment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "hotspot" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "icmp-options" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-bridge-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-bridge-port-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ingress-priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ipsec-policy" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ipv4-options" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "layer7-protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "log" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "log-prefix" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "nth" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-bridge-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-bridge-port-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "packet-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "packet-size" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "per-connection-classifier" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "psd" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "random" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "realm" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "routing-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "sniff-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "sniff-target" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "sniff-target-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tcp-mss" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tls-host" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ttl" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/firewall/calea";
    };

    tracking = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "enabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "generic-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "icmp-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "loose-tcp-tracking" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tcp-close-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "tcp-close-wait-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "tcp-established-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "tcp-fin-wait-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "tcp-last-ack-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "tcp-max-retrans-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "tcp-syn-received-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "tcp-syn-sent-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "tcp-time-wait-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "tcp-unacked-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "udp-stream-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "udp-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
        };
      };
      default = {};
      description = "Configuration for /ip/firewall/connection/tracking";
    };

    filter = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "action" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "address-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "address-list-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "..35w3d13h13m56s    (time interval)"; };
          "chain" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "connection-bytes" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-nat-state" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-rate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-state" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "content" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dscp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "fragment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "hotspot" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "hw-offload" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "icmp-options" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-bridge-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-bridge-port-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ingress-priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ipsec-policy" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ipv4-options" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "jump-target" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "layer7-protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "log" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "log-prefix" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "nth" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-bridge-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-bridge-port-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "p2p" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "packet-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "packet-size" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "per-connection-classifier" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "psd" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "random" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "realm" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "reject-with" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "routing-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tcp-flags" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tcp-mss" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tls-host" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ttl" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/firewall/filter";
    };

    layer7-protocol = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "regexp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /ip/firewall/layer7-protocol";
    };

    mangle = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "action" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "address-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "address-list-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "..35w3d13h13m56s    (time interval)"; };
          "chain" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "connection-bytes" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-nat-state" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-rate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-state" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "content" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dscp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "fragment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "hotspot" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "icmp-options" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-bridge-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-bridge-port-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ingress-priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ipsec-policy" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ipv4-options" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "jump-target" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "layer7-protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "log" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "log-prefix" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "new-connection-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "new-dscp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "new-mss" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "new-packet-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "new-priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "new-routing-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "new-ttl" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "nth" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-bridge-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-bridge-port-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "p2p" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "packet-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "packet-size" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "passthrough" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "per-connection-classifier" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "psd" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "random" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "realm" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "route-dst" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "routing-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "sniff-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "sniff-target" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "sniff-target-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tcp-flags" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tcp-mss" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tls-host" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ttl" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/firewall/mangle";
    };

    nat = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "action" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "address-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "address-list-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "..35w3d13h13m56s    (time interval)"; };
          "chain" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "connection-bytes" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-rate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "content" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dscp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "fragment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "hotspot" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "icmp-options" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-bridge-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-bridge-port-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ingress-priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ipsec-policy" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ipv4-options" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "jump-target" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "layer7-protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "log" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "log-prefix" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "nth" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-bridge-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-bridge-port-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "packet-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "packet-size" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "per-connection-classifier" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "psd" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "random" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "realm" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "routing-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "same-not-by-dst" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tcp-mss" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tls-host" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "to-addresses" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D[-A.B.C.D |0..32 |/A.B.C.D ]    (IP address range)"; };
          "to-ports" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ttl" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/firewall/nat";
    };

    raw = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "action" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "address-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "address-list-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "..35w3d13h13m56s    (time interval)"; };
          "chain" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "content" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dscp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "fragment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "hotspot" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "icmp-options" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-bridge-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-bridge-port-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ingress-priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ipsec-policy" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ipv4-options" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "jump-target" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "log" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "log-prefix" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "nth" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-bridge-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-bridge-port-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "packet-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "packet-size" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "per-connection-classifier" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "psd" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "random" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tcp-flags" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tcp-mss" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tls-host" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ttl" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/firewall/raw";
    };

    service-port = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "ports" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "sip-direct-media" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "sip-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
        };
      };
      default = {};
      description = "Configuration for /ip/firewall/service-port";
    };

    hotspot = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "address-pool" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "addresses-per-mac" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "idle-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "keepalive-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "login-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "profile" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/hotspot";
    };

    active = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/hotspot/active";
    };

    ip-binding = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D[-A.B.C.D |0..32 |/A.B.C.D ]    (IP address range)"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "server" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "to-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/hotspot/ip-binding";
    };

    profile = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dns-name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "hotspot-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "html-directory" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "html-directory-override" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "http-cookie-lifetime" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "http-proxy" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "install-hotspot-queue" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "login-by" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "mac|cookie|http-chap|https|http-pap|trial|mac-cookie[,LoginBy*]"; };
          "mac-auth-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mac-auth-password" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "nas-port-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "radius-accounting" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "radius-default-domain" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "radius-interim-update" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "radius-location-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "radius-location-name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "radius-mac-format" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "rate-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "smtp-server" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "split-user-domain" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ssl-certificate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "trial-uptime-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "trial-uptime-reset" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "trial-user-profile" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "use-radius" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/hotspot/profile";
    };

    service-port = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "ports" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /ip/hotspot/service-port";
    };

    user = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "email" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "limit-bytes-in" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "limit-bytes-out" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "limit-bytes-total" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "limit-uptime" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "password" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "profile" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "routes" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "server" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/hotspot/user";
    };

    profile = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "add-mac-cookie" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "address-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "address-pool" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "advertise" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "advertise-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "advertise-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "advertise-url" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "idle-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "incoming-filter" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "incoming-packet-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "insert-queue-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "keepalive-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "mac-cookie-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "on-login" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "on-logout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "open-status-page" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "outgoing-filter" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "outgoing-packet-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "parent-queue" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "queue-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "rate-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "session-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "shared-users" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "status-autorefresh" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "transparent-proxy" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/hotspot/user/profile";
    };

    walled-garden = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "action" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dst-host" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "method" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "path" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "server" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/hotspot/walled-garden";
    };

    ip = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "action" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-host" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "dst-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "server" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/hotspot/walled-garden/ip";
    };

    active-peers = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/ipsec/active-peers";
    };

    identity = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "auth-method" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "certificate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "eap-methods" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "generate-policy" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "key" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "match-by" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mode-config" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "my-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "notrack-chain" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "password" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "peer" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "policy-template-group" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "remote-certificate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "remote-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "remote-key" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "secret" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "username" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /ip/ipsec/identity";
    };

    key = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      };
      default = {};
      description = "Configuration for /ip/ipsec/key";
    };

    mode-config = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "address-pool" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "address-prefix-length" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "responder" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "split-dns" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "split-include" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D/M    (IP prefix)"; };
          "src-address-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "static-dns" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "system-dns" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "use-responder-dns" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/ipsec/mode-config";
    };

    peer = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "IPv6/0..128    (IPv6 prefix)"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "exchange-mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "local-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "passive" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "profile" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "send-initial-contact" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/ipsec/peer";
    };

    policy = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "action" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "IPv6/0..128    (IPv6 prefix)"; };
          "dst-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "group" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ipsec-protocols" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "level" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "peer" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "proposal" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "sa-dst-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "sa-src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "IPv6/0..128    (IPv6 prefix)"; };
          "src-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "template" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tunnel" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/ipsec/policy";
    };

    group = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /ip/ipsec/policy/group";
    };

    profile = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dh-group" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "x25519|ecp256|ecp384|ecp521|ec2n185|ec2n155|modp8192|modp6144|modp4096|modp3072|modp2048|modp1536|modp1024|modp768[,DhGroup*]"; };
          "dpd-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "..1h    (time interval)"; };
          "dpd-maximum-failures" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "enc-algorithm" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "aes-256|aes-192|aes-128|3des|des[,EncAlgorithm*]"; };
          "hash-algorithm" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "lifebytes" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "lifetime" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "nat-traversal" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "prf-algorithm" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "proposal-check" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/ipsec/profile";
    };

    proposal = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "auth-algorithms" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "sha512|sha256|sha1|md5|null[,AuthAlgorithms*]"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "enc-algorithms" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "chacha20poly1305|aes-256-cbc|aes-256-ctr|aes-256-gcm|camellia-256|aes-192-cbc|aes-192-ctr|aes-192-gcm|camellia-192|aes-128-cbc|aes-128-ctr|aes-128-gcm|camellia-128|3des|blowfish|twofish|des|null[,EncAlgorithms*]"; };
          "lifetime" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "pfs-group" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/ipsec/proposal";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "accounting" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interim-update" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "xauth-use-radius" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /ip/ipsec/settings";
    };

    kid-control = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "fri" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0s..1d    (time interval)"; };
          "mon" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0s..1d    (time interval)"; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "rate-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "sat" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0s..1d    (time interval)"; };
          "sun" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0s..1d    (time interval)"; };
          "thu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0s..1d    (time interval)"; };
          "tue" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0s..1d    (time interval)"; };
          "tur-fri" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0s..1d    (time interval)"; };
          "tur-mon" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0s..1d    (time interval)"; };
          "tur-sat" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0s..1d    (time interval)"; };
          "tur-sun" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0s..1d    (time interval)"; };
          "tur-thu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0s..1d    (time interval)"; };
          "tur-tue" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0s..1d    (time interval)"; };
          "tur-wed" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0s..1d    (time interval)"; };
          "wed" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0s..1d    (time interval)"; };
        };
      });
      default = {};
      description = "Configuration for /ip/kid-control";
    };

    device = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "user" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/kid-control/device";
    };

    discovery-settings = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "discover-interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "lldp-med-net-policy-vlan" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "cdp|lldp|mndp[,Protocol*]"; };
        };
      };
      default = {};
      description = "Configuration for /ip/neighbor/discovery-settings";
    };

    packing = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "aggregated-size" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "packing" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "unpacking" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/packing";
    };

    pool = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "next-pool" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ranges" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D[-A.B.C.D |0..32 |/A.B.C.D ]    (IP address range)"; };
        };
      });
      default = {};
      description = "Configuration for /ip/pool";
    };

    used = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "info" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "owner" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "pool" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /ip/pool/used";
    };

    proxy = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "always-from-cache" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "anonymous" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "cache-administrator" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "cache-hit-dscp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "cache-on-disk" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "cache-path" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "enabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-cache-object-size" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-cache-size" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-client-connections" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-fresh-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "max-server-connections" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "parent-proxy" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "parent-proxy-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "serialize-connections" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
        };
      };
      default = {};
      description = "Configuration for /ip/proxy";
    };

    access = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "action" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "action-data" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-host" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "local-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "method" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "path" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/proxy/access";
    };

    cache = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "action" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-host" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "local-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "method" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "path" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/proxy/cache";
    };

    cache-contents = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/proxy/cache-contents";
    };

    connections = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      };
      default = {};
      description = "Configuration for /ip/proxy/connections";
    };

    direct = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "action" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-host" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "local-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "method" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "path" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/proxy/direct";
    };

    route = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "blackhole" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "check-gateway" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "distance" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "gateway" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "pref-src" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "routing-table" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "scope" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "suppress-hw-offload" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "target-scope" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vrf-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/route";
    };

    service = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D/M    (IP prefix)"; };
          "certificate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tls-version" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vrf" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /ip/service";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "accept-redirects" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "accept-source-route" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "allow-fast-path" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "arp-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "icmp-rate-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "icmp-rate-mask" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ip-forward" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-neighbor-entries" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "route-cache" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "rp-filter" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "secure-redirects" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "send-redirects" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tcp-syncookies" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /ip/settings";
    };

    smb = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "allow-guests" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "domain" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "enabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interfaces" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /ip/smb";
    };

    shares = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "directory" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "max-sessions" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /ip/smb/shares";
    };

    users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "password" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "read-only" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/smb/users";
    };

    socks = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "auth-method" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-idle-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "enabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-connections" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "version" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vrf" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /ip/socks";
    };

    access = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "action" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/socks/access";
    };

    connections = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "dst-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "rx" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "tx" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /ip/socks/connections";
    };

    users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value, min length 1, max length 255"; };
          "only-one" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "password" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value, min length 1, max length 255"; };
          "rate-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /ip/socks/users";
    };

    ssh = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "allow-none-crypto" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "always-allow-password-login" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "forwarding-enabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "host-key-size" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "host-key-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "strong-crypto" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /ip/ssh";
    };

    tftp = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "allow" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "allow-overwrite" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "allow-rollover" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "ip-addresses" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "IPv6/0..128    (IPv6 prefix)"; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "read-only" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "reading-window-size" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "real-filename" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "req-filename" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /ip/tftp";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "max-block-size" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /ip/tftp/settings";
    };

    traffic-flow = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "active-flow-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..    (time interval)"; };
          "cache-entries" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "enabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "inactive-flow-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..    (time interval)"; };
          "interfaces" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "packet-sampling" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "sampling-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "sampling-space" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /ip/traffic-flow";
    };

    ipfix = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "bytes" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address-mask" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "first-forwarded" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "gateway" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "icmp-code" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "icmp-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "igmp-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ip-header-length" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ip-total-length" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ipv6-flow-label" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "is-multicast" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "last-forwarded" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "nat-dst-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "nat-dst-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "nat-events" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "nat-src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "nat-src-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "packets" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address-mask" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "sys-init-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tcp-ack-num" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tcp-flags" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tcp-seq-num" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tcp-window-size" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tos" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ttl" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "udp-length" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /ip/traffic-flow/ipfix";
    };

    target = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "v9-template-refresh" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "v9-template-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..    (time interval)"; };
          "version" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/traffic-flow/target";
    };

    upnp = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "allow-disable-external-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "enabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "show-dummy-rule" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /ip/upnp";
    };

    interfaces = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "forced-ip" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/upnp/interfaces";
    };

    vrf = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "interfaces" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ip/vrf";
    };

    address = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "advertise" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "eui-64" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "from-pool" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "no-dad" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ipv6/address";
    };

    dhcp-client = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "add-default-route" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "default-route-distance" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dhcp-options" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "pool-name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "pool-prefix-length" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "prefix-hint" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "IPv6/0..128    (IPv6 prefix)"; };
          "rapid-commit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "request" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "info|address|prefix[,Request*]"; };
          "script" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "use-interface-duid" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "use-peer-dns" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ipv6/dhcp-client";
    };

    option = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "code" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "value" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /ipv6/dhcp-client/option";
    };

    dhcp-relay = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "delay-threshold" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "dhcp-server" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "link-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /ipv6/dhcp-relay";
    };

    dhcp-server = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "address-pool" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "allow-dual-stack-queue" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "binding-script" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dhcp-option" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "insert-queue-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "lease-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "parent-queue" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "preference" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "rapid-commit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "route-distance" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "use-radius" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ipv6/dhcp-server";
    };

    binding = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "IPv6/0..128    (IPv6 prefix)"; };
          "address-lists" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "allow-dual-stack-queue" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dhcp-option" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "duid" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "iaid" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "insert-queue-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "life-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "prefix-pool" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "queue-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "rate-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "server" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ipv6/dhcp-server/binding";
    };

    option = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "code" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "value" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /ipv6/dhcp-server/option";
    };

    sets = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "options" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ipv6/dhcp-server/option/sets";
    };

    address-list = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "IPv6/0..128    (IPv6 prefix)"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dynamic" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
        };
      });
      default = {};
      description = "Configuration for /ipv6/firewall/address-list";
    };

    filter = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "action" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "address-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "address-list-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "chain" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "connection-bytes" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-nat-state" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-rate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-state" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "content" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dscp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "headers" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "hop-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "icmp-options" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-bridge-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-bridge-port-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ingress-priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ipsec-policy" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "jump-target" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "log" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "log-prefix" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "nth" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-bridge-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-bridge-port-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "packet-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "packet-size" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "per-connection-classifier" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "random" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "reject-with" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "routing-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tcp-flags" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tcp-mss" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tls-host" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ipv6/firewall/filter";
    };

    mangle = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "action" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "address-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "address-list-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "chain" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "connection-bytes" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-nat-state" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-rate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-state" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "content" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dscp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-prefix" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "IPv6/0..128    (IPv6 prefix)"; };
          "headers" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "hop-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "icmp-options" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-bridge-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-bridge-port-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ingress-priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ipsec-policy" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "jump-target" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "log" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "log-prefix" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "new-connection-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "new-dscp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "new-hop-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "new-mss" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "new-packet-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "new-priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "new-routing-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "nth" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-bridge-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-bridge-port-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "packet-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "packet-size" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "passthrough" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "per-connection-classifier" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "random" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "routing-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "sniff-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "sniff-target" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "sniff-target-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-prefix" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "IPv6/0..128    (IPv6 prefix)"; };
          "tcp-flags" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tcp-mss" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tls-host" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ipv6/firewall/mangle";
    };

    nat = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "action" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "address-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "address-list-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "chain" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "connection-bytes" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-rate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-state" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "connection-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "content" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dscp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "headers" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "hop-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "icmp-options" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-bridge-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-bridge-port-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ingress-priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ipsec-policy" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "jump-target" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "log" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "log-prefix" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "nth" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-bridge-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-bridge-port-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "packet-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "packet-size" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "per-connection-classifier" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "random" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "routing-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tcp-flags" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tcp-mss" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tls-host" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "to-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "IPv6/0..128    (IPv6 prefix)"; };
          "to-ports" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ipv6/firewall/nat";
    };

    raw = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "action" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "address-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "address-list-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "chain" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "content" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dscp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "headers" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "hop-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "icmp-options" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-bridge-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-bridge-port-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ingress-priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ipsec-policy" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "jump-target" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "log" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "log-prefix" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "nth" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-bridge-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-bridge-port-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "packet-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "packet-size" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "per-connection-classifier" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "random" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tcp-flags" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tcp-mss" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tls-host" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ipv6/firewall/raw";
    };

    nd = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "advertise-dns" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "advertise-mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dns" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "hop-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "managed-address-configuration" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "other-configuration" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "pref64" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "IPv6/0..128    (IPv6 prefix)"; };
          "ra-delay" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "ra-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "3s..20m50s    (time interval)"; };
          "ra-lifetime" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "..2h30m    (time interval)"; };
          "ra-preference" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "reachable-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "..1h    (time interval)"; };
          "retransmit-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
        };
      });
      default = {};
      description = "Configuration for /ipv6/nd";
    };

    prefix = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "6to4-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "autonomous" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "on-link" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "preferred-lifetime" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "prefix" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "IPv6/0..128    (IPv6 prefix)"; };
          "valid-lifetime" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
        };
      });
      default = {};
      description = "Configuration for /ipv6/nd/prefix";
    };

    default = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "autonomous" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "preferred-lifetime" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "valid-lifetime" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
        };
      };
      default = {};
      description = "Configuration for /ipv6/nd/prefix/default";
    };

    pool = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "prefix" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "IPv6/0..128    (IPv6 prefix)"; };
          "prefix-length" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ipv6/pool";
    };

    route = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "blackhole" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "check-gateway" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "distance" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "gateway" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "routing-table" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "scope" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "target-scope" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vrf-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ipv6/route";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "accept-redirects" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "accept-router-advertisements" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "disable-ipv6" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "forward" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-neighbor-entries" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /ipv6/settings";
    };

    interface = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "input" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mpls-mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /mpls/interface";
    };

    ldp = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "afi" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "ip|ipv6[,Afi*]"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "distribute-for-default" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "hop-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "loop-detect" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "lsr-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "path-vector-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "preferred-afi" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "transport-addresses" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "use-explicit-null" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vrf" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /mpls/ldp";
    };

    accept-filter = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "accept" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "neighbor" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "prefix" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "vrf" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /mpls/ldp/accept-filter";
    };

    advertise-filter = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "advertise" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "neighbor" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "prefix" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "vrf" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /mpls/ldp/advertise-filter";
    };

    interface = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "accept-dynamic-neighbors" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "afi" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "ip|ipv6[,Afi*]"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "hello-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "hold-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "transport-addresses" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
        };
      });
      default = {};
      description = "Configuration for /mpls/ldp/interface";
    };

    local-mapping = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "label" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vrf" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /mpls/ldp/local-mapping";
    };

    neighbor = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "send-targeted" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "transport" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
        };
      });
      default = {};
      description = "Configuration for /mpls/ldp/neighbor";
    };

    remote-mapping = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "label" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "nexthop" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "vrf" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /mpls/ldp/remote-mapping";
    };

    interface = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "bandwidth" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "blockade-k-factor" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "down-flood-thresholds" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "igp-flood-period" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "k-factor" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "refresh-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "resource-class" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "te-metric" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "up-flood-thresholds" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "use-udp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /mpls/traffic-eng/interface";
    };

    path = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "affinity-exclude" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "affinity-include-all" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "affinity-include-any" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "holding-priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "hops" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "record-route" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "reoptimize-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "setup-priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "use-cspf" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /mpls/traffic-eng/path";
    };

    tunnel = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "affinity-exclude" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "affinity-include-all" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "affinity-include-any" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "auto-bandwidth-avg-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..    (time interval)"; };
          "auto-bandwidth-range" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "auto-bandwidth-reserve" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "auto-bandwidth-update-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1m..    (time interval)"; };
          "bandwidth" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "bandwidth-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "from-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "holding-priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "primary-path" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "primary-retry-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "record-route" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "reoptimize-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "secondary-paths" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "secondary-standby" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "setup-priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "to-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "vrf" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /mpls/traffic-eng/tunnel";
    };

    port = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "baud-rate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "data-bits" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dtr" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "flow-control" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "parity" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "rts" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stop-bits" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /port";
    };

    remote-access = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "allowed-addresses" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D[-A.B.C.D |0..32 |/A.B.C.D ]    (IP address range)"; };
          "channel" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "local-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "log-file" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tcp-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /port/remote-access";
    };

    aaa = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "accounting" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interim-update" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "use-circuit-id-in-nas-port-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "use-radius" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /ppp/aaa";
    };

    l2tp-secret = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D/M    (IP prefix)"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "secret" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /ppp/l2tp-secret";
    };

    profile = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "address-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "bridge" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "bridge-horizon" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "bridge-learning" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "bridge-path-cost" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "bridge-port-priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "change-tcp-mss" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dhcpv6-pd-pool" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dns-server" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "idle-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "incoming-filter" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "insert-queue-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "local-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "on-down" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "on-up" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "only-one" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "outgoing-filter" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "parent-queue" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "queue-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "rate-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "remote-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "remote-ipv6-prefix-pool" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "session-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "use-compression" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "use-encryption" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "use-ipv6" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "use-mpls" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "use-upnp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "wins-server" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
        };
      });
      default = {};
      description = "Configuration for /ppp/profile";
    };

    secret = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "caller-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "ipv6-routes" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "limit-bytes-in" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "limit-bytes-out" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "local-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value, min length 1"; };
          "password" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "profile" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "remote-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "remote-ipv6-prefix" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "IPv6/0..128    (IPv6 prefix)"; };
          "routes" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "service" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /ppp/secret";
    };

    interface = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "queue" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /queue/interface";
    };

    simple = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "bucket-size" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "burst-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "burst-threshold" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "burst-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dst" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D/M    (IP prefix)"; };
          "limit-at" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "packet-marks" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "parent" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "queue" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "target" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D/M    (IP prefix)"; };
          "time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "total-bucket-size" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "total-burst-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "total-burst-threshold" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "total-burst-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "total-limit-at" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "total-max-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "total-priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "total-queue" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /queue/simple";
    };

    tree = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "bucket-size" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "burst-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "burst-threshold" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "burst-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "limit-at" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "packet-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "parent" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "queue" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /queue/tree";
    };

    type = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "bfifo-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "cake-ack-filter" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "cake-atm" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "cake-autorate-ingress" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "cake-bandwidth" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "cake-diffserv" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "cake-flowmode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "cake-memlimit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "cake-mpu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "cake-nat" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "cake-overhead" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "cake-overhead-scheme" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "cake-rtt" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0s..7101w3d6h28m15s    (time interval)"; };
          "cake-rtt-scheme" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "cake-wash" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "codel-ce-threshold" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0s..7101w3d6h28m15s    (time interval)"; };
          "codel-ecn" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "codel-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0s..7101w3d6h28m15s    (time interval)"; };
          "codel-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "codel-target" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0s..7101w3d6h28m15s    (time interval)"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "fq-codel-ce-threshold" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0s..7101w3d6h28m15s    (time interval)"; };
          "fq-codel-ecn" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "fq-codel-flows" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "fq-codel-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0s..7101w3d6h28m15s    (time interval)"; };
          "fq-codel-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "fq-codel-memlimit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "fq-codel-quantum" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "fq-codel-target" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0s..7101w3d6h28m15s    (time interval)"; };
          "kind" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mq-pfifo-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "pcq-burst-rate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "pcq-burst-threshold" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "pcq-burst-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..    (time interval)"; };
          "pcq-classifier" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "src-address|dst-address|src-port|dst-port[,PcqClassifier*]"; };
          "pcq-dst-address-mask" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "pcq-dst-address6-mask" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "pcq-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "pcq-rate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "pcq-src-address-mask" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "pcq-src-address6-mask" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "pcq-total-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "pfifo-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "red-avg-packet" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "red-burst" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "red-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "red-max-threshold" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "red-min-threshold" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "sfq-allot" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "sfq-perturb" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /queue/type";
    };

    radius = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "accounting-backup" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "accounting-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "authentication-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "called-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "certificate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "domain" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "realm" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "secret" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "service" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "ppp|login|hotspot|wireless|dhcp|ipsec|dot1x[,Service*]"; };
          "src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "10ms..1m    (time interval)"; };
        };
      });
      default = {};
      description = "Configuration for /radius";
    };

    incoming = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "accept" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vrf" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /radius/incoming";
    };

    connection = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "add-path-out" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "address-families" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "ip|ipv6|l2vpn|l2vpn-cisco|vpnv4[,AddressFamilies*]"; };
          "as" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0..4294967295"; };
          "as-override" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "cisco-vpls-nlri-len-fmt" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "cluster-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "connect" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "hold-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "3s..1h    (time interval)"; };
          "input.accept-communities" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "input.accept-ext-communities" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "input.accept-large-communities" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "input.accept-nlri" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "input.accept-unknown" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "input.affinity" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "input.allow-as" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "input.filter" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "input.ignore-as-path-len" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "input.limit-process-routes-ipv4" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "input.limit-process-routes-ipv6" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "keepalive-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..30m    (time interval)"; };
          "listen" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "local.address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "local.port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "local.role" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "local.ttl" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "multihop" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "nexthop-choice" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "output.affinity" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "output.default-originate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "output.default-prepend" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "output.filter-chain" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "output.filter-select" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "output.keep-sent-attributes" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "output.network" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "output.no-client-to-client-reflection" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "output.no-early-cut" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "output.redistribute" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "connected|static|rip|ospf|bgp|vpn|dhcp|fantasy|modem|bgp-mpls-vpn[,OutputRedistribute*]"; };
          "remote.address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "remote.allowed-as" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "remote.as" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0..4294967295"; };
          "remote.port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "remote.ttl" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "remove-private-as" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "router-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "routing-table" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "save-to" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "tcp-md5-key" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value, max length 80"; };
          "templates" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "use-bfd" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vrf" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /routing/bgp/connection";
    };

    template = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "add-path-out" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "address-families" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "ip|ipv6|l2vpn|l2vpn-cisco|vpnv4[,AddressFamilies*]"; };
          "as" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0..4294967295"; };
          "as-override" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "cisco-vpls-nlri-len-fmt" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "cluster-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "hold-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "3s..1h    (time interval)"; };
          "input.accept-communities" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "input.accept-ext-communities" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "input.accept-large-communities" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "input.accept-nlri" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "input.accept-unknown" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "input.affinity" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "input.allow-as" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "input.filter" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "input.ignore-as-path-len" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "input.limit-process-routes-ipv4" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "input.limit-process-routes-ipv6" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "keepalive-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..30m    (time interval)"; };
          "multihop" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "nexthop-choice" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "output.affinity" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "output.default-originate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "output.default-prepend" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "output.filter-chain" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "output.filter-select" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "output.keep-sent-attributes" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "output.network" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "output.no-client-to-client-reflection" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "output.no-early-cut" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "output.redistribute" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "connected|static|rip|ospf|bgp|vpn|dhcp|fantasy|modem|bgp-mpls-vpn[,OutputRedistribute*]"; };
          "remove-private-as" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "router-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "routing-table" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "save-to" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "templates" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "use-bfd" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vrf" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /routing/bgp/template";
    };

    vpls = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "bridge" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "bridge-cost" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "bridge-horizon" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "cisco-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "export-route-targets" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "import-route-targets" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "local-pref" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "pw-control-word" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "pw-l2mtu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "pw-type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "rd" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "site-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vrf" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /routing/bgp/vpls";
    };

    vpn = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "export.filter-chain" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "export.filter-select" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "export.redistribute" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "connected|static|rip|ospf|bgp|vpn|dhcp|fantasy|modem[,ExportRedistribute*]"; };
          "export.route-targets" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "import.filter-chain" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "import.route-targets" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "import.router-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "label-allocation-policy" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "route-distinguisher" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "vrf" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /routing/bgp/vpn";
    };

    fantasy = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "count" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dealer-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "gateway" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "instance-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "offset" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "prefix-length" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "priv-offs" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "priv-size" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "scope" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "seed" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "target-scope" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "use-hold" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /routing/fantasy";
    };

    community-ext-list = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "communities" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "regexp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /routing/filter/community-ext-list";
    };

    community-large-list = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "communities" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "regexp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /routing/filter/community-large-list";
    };

    community-list = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "communities" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "regexp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /routing/filter/community-list";
    };

    num-list = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "range" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /routing/filter/num-list";
    };

    rule = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "chain" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "rule" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /routing/filter/rule";
    };

    select-rule = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "chain" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "do-group-num" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "do-group-prfx" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "do-jump" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "do-select-num" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "do-select-prfx" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "do-take" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "do-where" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /routing/filter/select-rule";
    };

    gmp = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "exclude" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "groups" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "interfaces" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "sources" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
        };
      });
      default = {};
      description = "Configuration for /routing/gmp";
    };

    id = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "select-dynamic-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "any|only-static|only-loopback|only-vrf|only-active|lowest[,SelectDynamicId*]"; };
          "select-from-vrf" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /routing/id";
    };

    igmp-proxy = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "query-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..1h    (time interval)"; };
          "query-response-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..1h    (time interval)"; };
          "quick-leave" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /routing/igmp-proxy";
    };

    interface = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "alternative-subnets" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "threshold" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "upstream" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /routing/igmp-proxy/interface";
    };

    mfc = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "downstream-interfaces" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "group" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "source" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "upstream-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /routing/igmp-proxy/mfc";
    };

    area = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "area-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "default-cost" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "instance" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "no-summaries" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "nssa-translator" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /routing/ospf/area";
    };

    range = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "advertise" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "area" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "cost" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "prefix" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
        };
      });
      default = {};
      description = "Configuration for /routing/ospf/area/range";
    };

    instance = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "domain-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "domain-tag" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "in-filter-chain" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mpls-te-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "mpls-te-area" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "originate-default" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-filter-chain" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-filter-select" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "redistribute" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "connected|static|rip|ospf|bgp|vpn|dhcp|fantasy|modem|bgp-mpls-vpn[,Redistribute*]"; };
          "router-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "routing-table" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "use-dn" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "version" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vrf" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /routing/ospf/instance";
    };

    interface-template = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "area" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "auth" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "auth-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "auth-key" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "cost" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dead-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..18h12m15s    (time interval)"; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "hello-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..18h12m15s    (time interval)"; };
          "instance-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interfaces" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "networks" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "passive" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "prefix-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "retransmit-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..18h12m15s    (time interval)"; };
          "transmit-delay" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..18h12m15s    (time interval)"; };
          "type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vlink-neighbor-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "vlink-transit-area" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /routing/ospf/interface-template";
    };

    neighbor = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      };
      default = {};
      description = "Configuration for /routing/ospf/neighbor";
    };

    static-neighbor = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "area" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "instance-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "poll-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
        };
      });
      default = {};
      description = "Configuration for /routing/ospf/static-neighbor";
    };

    candidate = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "hashmask-length" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "instance" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "scope4" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "scope6" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /routing/pimsm/bsr/candidate";
    };

    rp-candidate = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "group" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "holdtime" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "instance" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /routing/pimsm/bsr/rp-candidate";
    };

    igmp-interface-template = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "instance" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interfaces" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /routing/pimsm/igmp-interface-template";
    };

    instance = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "afi" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "bsm-forward-back" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "crp-advertise-contained" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "rp-hash-mask-length" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "rp-static-override" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ssm-range" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "switch-to-spt" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "switch-to-spt-bytes" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "switch-to-spt-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "vrf" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /routing/pimsm/instance";
    };

    interface-template = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "hello-delay" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "hello-period" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "instance" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interfaces" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "join-prune-period" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "join-tracking-support" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "override-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "propagation-delay" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "source-addresses" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
        };
      });
      default = {};
      description = "Configuration for /routing/pimsm/interface-template";
    };

    static-rp = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "group" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "instance" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /routing/pimsm/static-rp";
    };

    instance = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "afi" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "in-filter-chain" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "originate-default" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-filter-chain" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "out-filter-select" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "redistribute" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "connected|static|rip|ospf|bgp|vpn|dhcp|fantasy|modem|bgp-mpls-vpn[,Redistribute*]"; };
          "route-gc-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "route-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "routing-table" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "update-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vrf" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /routing/rip/instance";
    };

    interface-template = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "cost" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "instance" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interfaces" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "key-chain" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "password" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value, max length 16"; };
          "poison-reverse" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "source-addresses" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "split-horizon" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /routing/rip/interface-template";
    };

    keys = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "chain" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "key" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value, max length 16"; };
          "key-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "valid-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "valid-till" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /routing/rip/keys";
    };

    static-neighbor = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "instance" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /routing/rip/static-neighbor";
    };

    route = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /routing/route";
    };

    rule = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "action" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "min-prefix" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "routing-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "table" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /routing/route/rule";
    };

    rpki = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "expire-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "group" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "preference" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "refresh-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "retry-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vrf" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /routing/rpki";
    };

    rule = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "action" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "dst-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "min-prefix" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "place-before" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "routing-mark" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "table" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /routing/rule";
    };

    table = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "fib" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /routing/table";
    };

    snmp = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "contact" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "enabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "engine-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "location" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "trap-community" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "trap-generators" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "trap-interfaces" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "trap-target" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "trap-version" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vrf" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /snmp";
    };

    community = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "addresses" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "IPv6/0..128    (IPv6 prefix)"; };
          "authentication-password" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "authentication-protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "encryption-password" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "encryption-protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "read-access" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "security" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "write-access" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /snmp/community";
    };

    special-login = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "channel" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "user" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /special-login";
    };

    clock = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "date" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "time-zone-autodetect" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "time-zone-name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /system/clock";
    };

    manual = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "dst-delta" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "dst-end" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dst-start" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "time-zone" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
        };
      };
      default = {};
      description = "Configuration for /system/clock/manual";
    };

    console = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "channel" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "term" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /system/console";
    };

    screen = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "blank-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "line-count" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /system/console/screen";
    };

    hardware = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "multi-cpu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /system/hardware";
    };

    health = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "state-after-reboot" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /system/health";
    };

    identity = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      };
      default = {};
      description = "Configuration for /system/identity";
    };

    leds = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "leds" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "modem-signal-threshold" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /system/leds";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "all-leds-off" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /system/leds/settings";
    };

    logging = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "action" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "prefix" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "topics" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /system/logging";
    };

    action = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "bsd-syslog" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "disk-file-count" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "disk-file-name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "disk-lines-per-file" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "disk-stop-on-full" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "email-start-tls" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "email-to" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "memory-lines" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "memory-stop-on-full" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "remember" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "remote" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "remote-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "syslog-facility" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "syslog-severity" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "syslog-time-format" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "target" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /system/logging/action";
    };

    note = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "note" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "show-at-login" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /system/note";
    };

    client = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "enabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mode" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "servers" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "vrf" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /system/ntp/client";
    };

    servers = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "auth-key" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "iburst" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-poll" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "min-poll" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /system/ntp/client/servers";
    };

    key = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "key-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "key-val" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /system/ntp/key";
    };

    server = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "auth-key" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "broadcast" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "broadcast-addresses" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "enabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "local-clock-stratum" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "manycast" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "multicast" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "use-local-clock" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vrf" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /system/ntp/server";
    };

    update = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "channel" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /system/package/update";
    };

    irq = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "cpu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /system/resource/irq";
    };

    rps = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /system/resource/irq/rps";
    };

    usb = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "device" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "device-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "ports" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "serial-number" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "speed" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "usb-version" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "vendor" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "vendor-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      };
      default = {};
      description = "Configuration for /system/resource/usb";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "authorization" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /system/resource/usb/settings";
    };

    scheduler = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "on-event" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "policy" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "start-date" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "start-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /system/scheduler";
    };

    script = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "dont-require-permissions" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "owner" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "policy" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "source" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /system/script";
    };

    environment = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "value" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      };
      default = {};
      description = "Configuration for /system/script/environment";
    };

    job = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "started" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /system/script/job";
    };

    upgrade = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "download" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /system/upgrade";
    };

    mirror = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "check-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "12h..    (time interval)"; };
          "enabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "password" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "primary-server" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "secondary-server" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "user" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      };
      default = {};
      description = "Configuration for /system/upgrade/mirror";
    };

    upgrade-package-source = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "user" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /system/upgrade/upgrade-package-source";
    };

    ups = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "alarm-setting" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "check-capabilities" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "min-runtime" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "offline-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /system/ups";
    };

    watchdog = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "auto-send-supout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "automatic-supout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ping-start-after-boot" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "ping-timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "10s..10m    (time interval)"; };
          "send-email-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "send-email-to" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "send-smtp-server" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "watch-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "none | A.B.C.D    (IP address)"; };
          "watchdog-timer" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /system/watchdog";
    };

    task = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "append" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "file-name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "max-lines" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-size" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "no-header-paging" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "save-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "10s..1h    (time interval)"; };
          "save-timestamp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "source" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "switch-to" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /task";
    };

    bandwidth-server = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "allocate-udp-ports-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "authenticate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "enabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "max-sessions" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /tool/bandwidth-server";
    };

    e-mail = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "password" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value, max length 255"; };
          "port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tls" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "user" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value, max length 255"; };
          "vrf" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /tool/e-mail";
    };

    graphing = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "page-refresh" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "store-every" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /tool/graphing";
    };

    interface = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "allow-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D/M    (IP prefix)"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "store-on-disk" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /tool/graphing/interface";
    };

    queue = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "allow-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D/M    (IP prefix)"; };
          "allow-target" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "simple-queue" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "store-on-disk" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /tool/graphing/queue";
    };

    resource = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "allow-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D/M    (IP prefix)"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "store-on-disk" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /tool/graphing/resource";
    };

    mac-server = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "allowed-interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /tool/mac-server";
    };

    mac-winbox = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "allowed-interface-list" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /tool/mac-server/mac-winbox";
    };

    ping = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "enabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /tool/mac-server/ping";
    };

    sessions = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "src-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "uptime" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
        };
      };
      default = {};
      description = "Configuration for /tool/mac-server/sessions";
    };

    netwatch = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "certificate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "check-certificate" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "down-script" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "host" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "http-codes" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "1s..71w2h27m52s950ms    (time interval)"; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "packet-count" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "packet-interval" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "20ms..71w2h27m52s950ms    (time interval)"; };
          "packet-size" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "start-delay" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0s..1h    (time interval)"; };
          "startup-delay" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "0s..1h    (time interval)"; };
          "test-script" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "thr-avg" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "thr-http-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "thr-jitter" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "thr-loss-count" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "thr-loss-percent" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "thr-max" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "thr-stdev" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "thr-tcp-conn-time" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "timeout" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "10ms..4w    (time interval)"; };
          "type" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "up-script" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /tool/netwatch";
    };

    romon = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "enabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "secrets" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      };
      default = {};
      description = "Configuration for /tool/romon";
    };

    port = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "cost" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "forbid" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "secrets" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /tool/romon/port";
    };

    sms = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "allowed-number" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "auto-erase" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "channel" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "receive-enabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "secret" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "sim-pin" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      };
      default = {};
      description = "Configuration for /tool/sms";
    };

    sniffer = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "file-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "file-name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "filter-cpu" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "filter-direction" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "filter-dst-ip-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "filter-dst-ipv6-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "filter-dst-mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "filter-dst-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "filter-interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "filter-ip-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "filter-ip-protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "filter-ipv6-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "filter-mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "filter-mac-protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "filter-operator-between-entries" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "filter-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "filter-size" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "filter-src-ip-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "filter-src-ipv6-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "filter-src-mac-address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "filter-src-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "filter-stream" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "filter-vlan" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "memory-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "memory-scroll" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "only-headers" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "streaming-enabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "streaming-server" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
        };
      };
      default = {};
      description = "Configuration for /tool/sniffer";
    };

    traffic-generator = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "latency-distribution-max" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "measure-out-of-order" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "stats-samples-to-keep" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "test-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /tool/traffic-generator";
    };

    packet-template = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "compute-checksum-from-offset" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "data" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "data-byte" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "header-stack" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ip-dscp" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ip-dst" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D[-A.B.C.D |0..32 |/A.B.C.D ]    (IP address range)"; };
          "ip-frag-off" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ip-gateway" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D    (IP address)"; };
          "ip-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ip-protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ip-src" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D[-A.B.C.D |0..32 |/A.B.C.D ]    (IP address range)"; };
          "ip-ttl" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ipv6-dst" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "IPv6/0..128    (IPv6 prefix)"; };
          "ipv6-flow-label" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ipv6-gateway" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "see documentation"; };
          "ipv6-hop-limit" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ipv6-next-header" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ipv6-src" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "IPv6/0..128    (IPv6 prefix)"; };
          "ipv6-traffic-class" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mac-dst" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "mac-protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mac-src" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)"; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "random-byte-offsets-and-masks" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "random-ranges" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "raw-header" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "special-footer" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tcp-ack" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tcp-data-offset" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tcp-dst-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tcp-flags" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "fin|syn|rst|psh|ack|urg|ece|cwr|ns|res0|res1|res2[,Flags*]"; };
          "tcp-src-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tcp-syn" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tcp-urgent-pointer" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tcp-window-size" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "udp-checksum" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "udp-dst-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "udp-src-port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vlan-id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vlan-priority" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "vlan-protocol" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /tool/traffic-generator/packet-template";
    };

    port = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /tool/traffic-generator/port";
    };

    raw-packet-template = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "compute-checksum-from-offset" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "data" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "data-byte" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "header" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "ip-header-offset" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "ipv6-header-offset" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "random-byte-offsets-and-masks" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "random-ranges" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "special-footer" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tcp-header-offset" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "udp-compute-checksum" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "udp-header-offset" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /tool/traffic-generator/raw-packet-template";
    };

    stream = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "cpu-core" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "id" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "mbps" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "packet-count" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "packet-size" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "port" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "pps" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "tx-template" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /tool/traffic-generator/stream";
    };

    traffic-monitor = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "interface" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "on-event" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "threshold" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "traffic" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "trigger" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /tool/traffic-monitor";
    };

    user = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "address" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "A.B.C.D/M    (IP prefix)"; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          enable = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "Inverts ROS disabled flag. Null translates to explicit removal."; };
          "disabled" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = ""; };
          "group" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "password" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
        };
      });
      default = {};
      description = "Configuration for /user";
    };

    aaa = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "accounting" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "default-group" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "exclude-groups" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "interim-update" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "time interval"; };
          "use-radius" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /user/aaa";
    };

    group = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "name" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "policy" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "skin" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /user/group";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        options = {
          "minimum-categories" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "minimum-password-length" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      };
      default = {};
      description = "Configuration for /user/settings";
    };

    ssh-keys = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          stub = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); default = "_UNSPECIFIED_"; description = "If true, use 'set' instead of 'add' to modify an existing item."; };
          "comment" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "copy-from" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
          "key" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = "string value"; };
          "user" = lib.mkOption { type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.str); default = "_UNSPECIFIED_"; description = ""; };
        };
      });
      default = {};
      description = "Configuration for /user/ssh-keys";
    };

  };
  config = {
    # Expose the final generated RouterOS script
    build.rscScript = ''
      # Generated by NixOS-to-RouterOS Compiler
      # Warning: Do not edit manually!

      # Interfaces
      ${buildScript config.interface "interface"}
      ${buildScript config.interface.bridge "interface bridge"}
      ${buildScript config.interface.pppoe-client "interface pppoe-client"}

      # IP Configuration
      ${buildScript config.ip.pool "ip pool"}
      ${buildScript config.ip.dhcp-server "ip dhcp-server"}
      ${buildScript config.ip.address "ip address"}
      ${buildScript config.ip.dhcp-client "ip dhcp-client"}

      # TODO: Register additional parsed dynamic module paths here...
    '';
  };
}
