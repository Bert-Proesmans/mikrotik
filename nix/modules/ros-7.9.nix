{ config, lib, pkgs, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) submodule attrsOf str;
in
{
  options = {
    "caps-man" = mkOption {
      description = "";
      default = {};
      type = submodule {
        options = {
          aaa = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                "called-format" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "interim-update" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "mac-caching" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "mac-format" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "mac-mode" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "aaa";
                };
              };
            };
          };
          "access-list" = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                action = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "allow-signal-out-of-range" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "ap-tx-limit" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "client-to-client-forwarding" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "client-tx-limit" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                interface = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "mac-address" = mkOption {
                  description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)";
                  default = null;
                  type = lib.types.str;
                };
                "mac-address-mask" = mkOption {
                  description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)";
                  default = null;
                  type = lib.types.str;
                };
                "place-before" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "private-passphrase" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "radius-accounting" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "signal-range" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "ssid-regexp" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                time = mkOption {
                  description = "0s..1d    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "vlan-id" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "vlan-mode" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "\"access-list\"";
                };
              };
            };
          };
          "actual-interface-configuration" = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                arp = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "arp-timeout" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "channel.band" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "channel.control-channel-width" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "channel.extension-channel" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "channel.frequency" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "channel.reselect-interval" = mkOption {
                  description = "1s..42w6d    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "channel.save-selected" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "channel.secondary-frequency" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "channel.skip-dfs-channels" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "channel.tx-power" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "configuration.country" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "configuration.disconnect-timeout" = mkOption {
                  description = "0s..15s    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "configuration.distance" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "configuration.frame-lifetime" = mkOption {
                  description = "0s..15s    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "configuration.guard-interval" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "configuration.hide-ssid" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "configuration.hw-protection-mode" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "configuration.hw-retries" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "configuration.installation" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "configuration.keepalive-frames" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "configuration.load-balancing-group" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "configuration.max-sta-count" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "configuration.mode" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "configuration.multicast-helper" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "configuration.rx-chains" = mkOption {
                  description = "0|1|2|3[,ConfigurationRxChains*]";
                  default = null;
                  type = lib.types.str;
                };
                "configuration.ssid" = mkOption {
                  description = "string value, max length 32";
                  default = null;
                  type = lib.types.str;
                };
                "configuration.tx-chains" = mkOption {
                  description = "0|1|2|3[,ConfigurationTxChains*]";
                  default = null;
                  type = lib.types.str;
                };
                "datapath.bridge" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "datapath.bridge-cost" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "datapath.bridge-horizon" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "datapath.client-to-client-forwarding" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "datapath.interface-list" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "datapath.local-forwarding" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "datapath.openflow-switch" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "datapath.vlan-id" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "datapath.vlan-mode" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "disable-running-check" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                l2mtu = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "mac-address" = mkOption {
                  description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)";
                  default = null;
                  type = lib.types.str;
                };
                "master-interface" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                mtu = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "radio-mac" = mkOption {
                  description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)";
                  default = null;
                  type = lib.types.str;
                };
                "security.authentication-types" = mkOption {
                  description = "wpa-psk|wpa2-psk|wpa-eap|wpa2-eap[,SecurityAuthenticationTypes*]";
                  default = null;
                  type = lib.types.str;
                };
                "security.disable-pmkid" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "security.eap-methods" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "security.eap-radius-accounting" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "security.encryption" = mkOption {
                  description = "aes-ccm|tkip[,SecurityEncryption*]";
                  default = null;
                  type = lib.types.str;
                };
                "security.group-encryption" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "security.group-key-update" = mkOption {
                  description = "30s..1d    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "security.passphrase" = mkOption {
                  description = "string value, min length 8, max length 63";
                  default = null;
                  type = lib.types.str;
                };
                "security.tls-certificate" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "security.tls-mode" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "\"actual-interface-configuration\"";
                };
              };
            };
          };
          channel = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                band = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "control-channel-width" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "extension-channel" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                frequency = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "reselect-interval" = mkOption {
                  description = "1s..42w6d    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "save-selected" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "secondary-frequency" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "skip-dfs-channels" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "tx-power" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "channel";
                };
              };
            };
          };
          configuration = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                channel = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "channel.band" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "channel.control-channel-width" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "channel.extension-channel" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "channel.frequency" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "channel.reselect-interval" = mkOption {
                  description = "1s..42w6d    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "channel.save-selected" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "channel.secondary-frequency" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "channel.skip-dfs-channels" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "channel.tx-power" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                country = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                datapath = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "datapath.arp" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "datapath.bridge" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "datapath.bridge-cost" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "datapath.bridge-horizon" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "datapath.client-to-client-forwarding" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "datapath.interface-list" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "datapath.l2mtu" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "datapath.local-forwarding" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "datapath.mtu" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "datapath.openflow-switch" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "datapath.vlan-id" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "datapath.vlan-mode" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "disconnect-timeout" = mkOption {
                  description = "0s..15s    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                distance = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "frame-lifetime" = mkOption {
                  description = "0s..15s    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "guard-interval" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "hide-ssid" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "hw-protection-mode" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "hw-retries" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                installation = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "keepalive-frames" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "load-balancing-group" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "max-sta-count" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                mode = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "multicast-helper" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                rates = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "rates.basic" = mkOption {
                  description = "1Mbps|2Mbps|5.5Mbps|11Mbps|6Mbps|9Mbps|12Mbps|18Mbps|24Mbps|36Mbps|48Mbps|54Mbps[,RatesBasic*]";
                  default = null;
                  type = lib.types.str;
                };
                "rates.ht-basic-mcs" = mkOption {
                  description = "mcs-0|mcs-1|mcs-2|mcs-3|mcs-4|mcs-5|mcs-6|mcs-7|mcs-8|mcs-9|mcs-10|mcs-11|mcs-12|mcs-13|mcs-14|mcs-15|mcs-16|mcs-17|mcs-18|mcs-19|mcs-20|mcs-21|mcs-22|mcs-23[,RatesHtBasicMcs*]";
                  default = null;
                  type = lib.types.str;
                };
                "rates.ht-supported-mcs" = mkOption {
                  description = "mcs-0|mcs-1|mcs-2|mcs-3|mcs-4|mcs-5|mcs-6|mcs-7|mcs-8|mcs-9|mcs-10|mcs-11|mcs-12|mcs-13|mcs-14|mcs-15|mcs-16|mcs-17|mcs-18|mcs-19|mcs-20|mcs-21|mcs-22|mcs-23[,RatesHtSupportedMcs*]";
                  default = null;
                  type = lib.types.str;
                };
                "rates.supported" = mkOption {
                  description = "1Mbps|2Mbps|5.5Mbps|11Mbps|6Mbps|9Mbps|12Mbps|18Mbps|24Mbps|36Mbps|48Mbps|54Mbps[,RatesSupported*]";
                  default = null;
                  type = lib.types.str;
                };
                "rates.vht-basic-mcs" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "rates.vht-supported-mcs" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "rx-chains" = mkOption {
                  description = "0|1|2|3[,RxChains*]";
                  default = null;
                  type = lib.types.str;
                };
                security = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "security.authentication-types" = mkOption {
                  description = "wpa-psk|wpa2-psk|wpa-eap|wpa2-eap[,SecurityAuthenticationTypes*]";
                  default = null;
                  type = lib.types.str;
                };
                "security.disable-pmkid" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "security.eap-methods" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "security.eap-radius-accounting" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "security.encryption" = mkOption {
                  description = "aes-ccm|tkip[,SecurityEncryption*]";
                  default = null;
                  type = lib.types.str;
                };
                "security.group-encryption" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "security.group-key-update" = mkOption {
                  description = "30s..1d    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "security.passphrase" = mkOption {
                  description = "string value, min length 8, max length 63";
                  default = null;
                  type = lib.types.str;
                };
                "security.tls-certificate" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "security.tls-mode" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                ssid = mkOption {
                  description = "string value, max length 32";
                  default = null;
                  type = lib.types.str;
                };
                "tx-chains" = mkOption {
                  description = "0|1|2|3[,TxChains*]";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "configuration";
                };
              };
            };
          };
          datapath = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                arp = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                bridge = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "bridge-cost" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "bridge-horizon" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "client-to-client-forwarding" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "interface-list" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                l2mtu = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "local-forwarding" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                mtu = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "openflow-switch" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "vlan-id" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "vlan-mode" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "datapath";
                };
              };
            };
          };
          interface = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                arp = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "arp-timeout" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                channel = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "channel.band" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "channel.control-channel-width" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "channel.extension-channel" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "channel.frequency" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "channel.reselect-interval" = mkOption {
                  description = "1s..42w6d    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "channel.save-selected" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "channel.secondary-frequency" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "channel.skip-dfs-channels" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "channel.tx-power" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                configuration = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "configuration.country" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "configuration.disconnect-timeout" = mkOption {
                  description = "0s..15s    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "configuration.distance" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "configuration.frame-lifetime" = mkOption {
                  description = "0s..15s    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "configuration.guard-interval" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "configuration.hide-ssid" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "configuration.hw-protection-mode" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "configuration.hw-retries" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "configuration.installation" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "configuration.keepalive-frames" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "configuration.load-balancing-group" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "configuration.max-sta-count" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "configuration.mode" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "configuration.multicast-helper" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "configuration.rx-chains" = mkOption {
                  description = "0|1|2|3[,ConfigurationRxChains*]";
                  default = null;
                  type = lib.types.str;
                };
                "configuration.ssid" = mkOption {
                  description = "string value, max length 32";
                  default = null;
                  type = lib.types.str;
                };
                "configuration.tx-chains" = mkOption {
                  description = "0|1|2|3[,ConfigurationTxChains*]";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                datapath = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "datapath.bridge" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "datapath.bridge-cost" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "datapath.bridge-horizon" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "datapath.client-to-client-forwarding" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "datapath.interface-list" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "datapath.local-forwarding" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "datapath.openflow-switch" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "datapath.vlan-id" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "datapath.vlan-mode" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "disable-running-check" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                l2mtu = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "mac-address" = mkOption {
                  description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)";
                  default = null;
                  type = lib.types.str;
                };
                "master-interface" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                mtu = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "radio-mac" = mkOption {
                  description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)";
                  default = null;
                  type = lib.types.str;
                };
                "radio-name" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                rates = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "rates.basic" = mkOption {
                  description = "1Mbps|2Mbps|5.5Mbps|11Mbps|6Mbps|9Mbps|12Mbps|18Mbps|24Mbps|36Mbps|48Mbps|54Mbps[,RatesBasic*]";
                  default = null;
                  type = lib.types.str;
                };
                "rates.ht-basic-mcs" = mkOption {
                  description = "mcs-0|mcs-1|mcs-2|mcs-3|mcs-4|mcs-5|mcs-6|mcs-7|mcs-8|mcs-9|mcs-10|mcs-11|mcs-12|mcs-13|mcs-14|mcs-15|mcs-16|mcs-17|mcs-18|mcs-19|mcs-20|mcs-21|mcs-22|mcs-23[,RatesHtBasicMcs*]";
                  default = null;
                  type = lib.types.str;
                };
                "rates.ht-supported-mcs" = mkOption {
                  description = "mcs-0|mcs-1|mcs-2|mcs-3|mcs-4|mcs-5|mcs-6|mcs-7|mcs-8|mcs-9|mcs-10|mcs-11|mcs-12|mcs-13|mcs-14|mcs-15|mcs-16|mcs-17|mcs-18|mcs-19|mcs-20|mcs-21|mcs-22|mcs-23[,RatesHtSupportedMcs*]";
                  default = null;
                  type = lib.types.str;
                };
                "rates.supported" = mkOption {
                  description = "1Mbps|2Mbps|5.5Mbps|11Mbps|6Mbps|9Mbps|12Mbps|18Mbps|24Mbps|36Mbps|48Mbps|54Mbps[,RatesSupported*]";
                  default = null;
                  type = lib.types.str;
                };
                "rates.vht-basic-mcs" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "rates.vht-supported-mcs" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                security = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "security.authentication-types" = mkOption {
                  description = "wpa-psk|wpa2-psk|wpa-eap|wpa2-eap[,SecurityAuthenticationTypes*]";
                  default = null;
                  type = lib.types.str;
                };
                "security.disable-pmkid" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "security.eap-methods" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "security.eap-radius-accounting" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "security.encryption" = mkOption {
                  description = "aes-ccm|tkip[,SecurityEncryption*]";
                  default = null;
                  type = lib.types.str;
                };
                "security.group-encryption" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "security.group-key-update" = mkOption {
                  description = "30s..1d    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "security.passphrase" = mkOption {
                  description = "string value, min length 8, max length 63";
                  default = null;
                  type = lib.types.str;
                };
                "security.tls-certificate" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "security.tls-mode" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "interface";
                };
              };
            };
          };
          manager = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                "ca-certificate" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                certificate = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enabled = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "package-path" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "require-peer-certificate" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "upgrade-policy" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "manager";
                };
              };
            };
          };
          provisioning = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                action = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "common-name-regexp" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "hw-supported-modes" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "identity-regexp" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "ip-address-ranges" = mkOption {
                  description = "A.B.C.D[-A.B.C.D |0..32 |/A.B.C.D ]    (IP address range)";
                  default = null;
                  type = lib.types.str;
                };
                "master-configuration" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "name-format" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "name-prefix" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "place-before" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "radio-mac" = mkOption {
                  description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)";
                  default = null;
                  type = lib.types.str;
                };
                "slave-configurations" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "provisioning";
                };
              };
            };
          };
          radio = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
              };
            };
          };
          rates = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                basic = mkOption {
                  description = "1Mbps|2Mbps|5.5Mbps|11Mbps|6Mbps|9Mbps|12Mbps|18Mbps|24Mbps|36Mbps|48Mbps|54Mbps[,Basic*]";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "ht-basic-mcs" = mkOption {
                  description = "mcs-0|mcs-1|mcs-2|mcs-3|mcs-4|mcs-5|mcs-6|mcs-7|mcs-8|mcs-9|mcs-10|mcs-11|mcs-12|mcs-13|mcs-14|mcs-15|mcs-16|mcs-17|mcs-18|mcs-19|mcs-20|mcs-21|mcs-22|mcs-23[,HtBasicMcs*]";
                  default = null;
                  type = lib.types.str;
                };
                "ht-supported-mcs" = mkOption {
                  description = "mcs-0|mcs-1|mcs-2|mcs-3|mcs-4|mcs-5|mcs-6|mcs-7|mcs-8|mcs-9|mcs-10|mcs-11|mcs-12|mcs-13|mcs-14|mcs-15|mcs-16|mcs-17|mcs-18|mcs-19|mcs-20|mcs-21|mcs-22|mcs-23[,HtSupportedMcs*]";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                supported = mkOption {
                  description = "1Mbps|2Mbps|5.5Mbps|11Mbps|6Mbps|9Mbps|12Mbps|18Mbps|24Mbps|36Mbps|48Mbps|54Mbps[,Supported*]";
                  default = null;
                  type = lib.types.str;
                };
                "vht-basic-mcs" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "vht-supported-mcs" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "rates";
                };
              };
            };
          };
          "registration-table" = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
              };
            };
          };
          "remote-cap" = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
              };
            };
          };
          security = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "authentication-types" = mkOption {
                  description = "wpa-psk|wpa2-psk|wpa-eap|wpa2-eap[,AuthenticationTypes*]";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "disable-pmkid" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "eap-methods" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "eap-radius-accounting" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                encryption = mkOption {
                  description = "aes-ccm|tkip[,Encryption*]";
                  default = null;
                  type = lib.types.str;
                };
                "group-encryption" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "group-key-update" = mkOption {
                  description = "30s..1d    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                passphrase = mkOption {
                  description = "string value, min length 8, max length 63";
                  default = null;
                  type = lib.types.str;
                };
                "tls-certificate" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "tls-mode" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "security";
                };
              };
            };
          };
        };
      };
    };
    certificate = mkOption {
      description = "";
      default = {};
      type = attrsOf submodule {
        options = {
          "common-name" = mkOption {
            description = "string value";
            default = null;
            type = lib.types.str;
          };
          "copy-from" = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          country = mkOption {
            description = "string value";
            default = null;
            type = lib.types.str;
          };
          "days-valid" = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          "digest-algorithm" = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          "key-size" = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          "key-usage" = mkOption {
            description = "digital-signature|content-commitment|key-encipherment|data-encipherment|key-agreement|key-cert-sign|crl-sign|encipher-only|decipher-only|tls-server|tls-client|code-sign|email-protect|timestamp|ocsp-sign[,KeyUsage*]";
            default = null;
            type = lib.types.str;
          };
          locality = mkOption {
            description = "string value";
            default = null;
            type = lib.types.str;
          };
          name = mkOption {
            description = "string value";
            default = null;
            type = lib.types.str;
          };
          organization = mkOption {
            description = "string value";
            default = null;
            type = lib.types.str;
          };
          state = mkOption {
            description = "string value";
            default = null;
            type = lib.types.str;
          };
          "subject-alt-name" = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          trusted = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          unit = mkOption {
            description = "string value";
            default = null;
            type = lib.types.str;
          };
          numbers = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          _create = mkOption {
            description = "Creation script";
            internal = true;
            readOnly = true;
            type = lib.types.str;
            default = "# " + "certificate";
          };
        };
      };
    };
    console = mkOption {
      description = "";
      default = {};
      type = submodule {
        options = {
        };
      };
    };
    disk = mkOption {
      description = "";
      default = {};
      type = attrsOf submodule {
        options = {
          comment = mkOption {
            description = "string value";
            default = null;
            type = lib.types.str;
          };
          "copy-from" = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          enable = mkOption {
            description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
            default = null;
            type = lib.types.str;
          };
          parent = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          "partition-number" = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          "partition-offset" = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          "partition-size" = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          slot = mkOption {
            description = "string value, max length 32";
            default = null;
            type = lib.types.str;
          };
          "tmpfs-max-size" = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          type = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          numbers = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          _create = mkOption {
            description = "Creation script";
            internal = true;
            readOnly = true;
            type = lib.types.str;
            default = "# " + "disk";
          };
        };
      };
    };
    environment = mkOption {
      description = "";
      default = {};
      type = submodule {
        options = {
        };
      };
    };
    file = mkOption {
      description = "";
      default = {};
      type = attrsOf submodule {
        options = {
          contents = mkOption {
            description = "string value";
            default = null;
            type = lib.types.str;
          };
          "copy-from" = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          name = mkOption {
            description = "string value";
            default = null;
            type = lib.types.str;
          };
          numbers = mkOption {
            description = "see documentation";
            default = null;
            type = lib.types.str;
          };
          _create = mkOption {
            description = "Creation script";
            internal = true;
            readOnly = true;
            type = lib.types.str;
            default = "# " + "file";
          };
        };
      };
    };
    interface = mkOption {
      description = "";
      default = {};
      type = submodule {
        options = {
          "6to4" = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "clamp-tcp-mss" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "dont-fragment" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                dscp = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "ipsec-secret" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                keepalive = mkOption {
                  description = "1s..    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "local-address" = mkOption {
                  description = "A.B.C.D    (IP address)";
                  default = null;
                  type = lib.types.str;
                };
                mtu = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "remote-address" = mkOption {
                  description = "unspecified | A.B.C.D    (IP address)";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "\"6to4\"";
                };
              };
            };
          };
          bonding = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                arp = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "arp-interval" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "arp-ip-targets" = mkOption {
                  description = "A.B.C.D    (IP address)";
                  default = null;
                  type = lib.types.str;
                };
                "arp-timeout" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "down-delay" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "forced-mac-address" = mkOption {
                  description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)";
                  default = null;
                  type = lib.types.str;
                };
                "lacp-rate" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "lacp-user-key" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "link-monitoring" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "mii-interval" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "min-links" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "mlag-id" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                mode = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                mtu = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                primary = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                slaves = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "transmit-hash-policy" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "up-delay" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "bonding";
                };
              };
            };
          };
          bridge = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "add-dhcp-option82" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "admin-mac" = mkOption {
                  description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)";
                  default = null;
                  type = lib.types.str;
                };
                "ageing-time" = mkOption {
                  description = "10s..1w4d13h46m40s    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                arp = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "arp-timeout" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "auto-mac" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "dhcp-snooping" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "ether-type" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "fast-forward" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "forward-delay" = mkOption {
                  description = "4s..30s    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "frame-types" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "igmp-snooping" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "igmp-version" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "ingress-filtering" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "last-member-interval" = mkOption {
                  description = "1s..    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "last-member-query-count" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "max-hops" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "max-message-age" = mkOption {
                  description = "6s..40s    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "membership-interval" = mkOption {
                  description = "1s..    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "mld-version" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                mtu = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "multicast-querier" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "multicast-router" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                priority = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "protocol-mode" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                pvid = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "querier-interval" = mkOption {
                  description = "1s..    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "query-interval" = mkOption {
                  description = "1s..    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "query-response-interval" = mkOption {
                  description = "1s..    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "region-name" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "region-revision" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "startup-query-count" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "startup-query-interval" = mkOption {
                  description = "1s..    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "transmit-hold-count" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "vlan-filtering" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "bridge";
                };
              };
            };
          };
          "detect-internet" = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                "detect-interface-list" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "internet-interface-list" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "lan-interface-list" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "wan-interface-list" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "\"detect-internet\"";
                };
              };
            };
          };
          dot1x = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                client = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      "anon-identity" = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      certificate = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      "eap-methods" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      identity = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      interface = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      password = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "client";
                      };
                    };
                  };
                };
                server = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      accounting = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "auth-timeout" = mkOption {
                        description = "100ms..    (time interval)";
                        default = null;
                        type = lib.types.str;
                      };
                      "auth-types" = mkOption {
                        description = "dot1x|mac-auth[,AuthTypes*]";
                        default = null;
                        type = lib.types.str;
                      };
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      "guest-vlan-id" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      interface = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "interim-update" = mkOption {
                        description = "time interval";
                        default = null;
                        type = lib.types.str;
                      };
                      "mac-auth-mode" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "radius-mac-format" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "reauth-timeout" = mkOption {
                        description = "1s..    (time interval)";
                        default = null;
                        type = lib.types.str;
                      };
                      "reject-vlan-id" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "retrans-timeout" = mkOption {
                        description = "100ms..    (time interval)";
                        default = null;
                        type = lib.types.str;
                      };
                      "server-fail-vlan-id" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "server";
                      };
                    };
                  };
                };
              };
            };
          };
          eoip = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "allow-fast-path" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                arp = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "arp-timeout" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "clamp-tcp-mss" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "dont-fragment" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                dscp = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "ipsec-secret" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                keepalive = mkOption {
                  description = "1s..    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "local-address" = mkOption {
                  description = "A.B.C.D    (IP address)";
                  default = null;
                  type = lib.types.str;
                };
                "loop-protect" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "loop-protect-disable-time" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "loop-protect-send-interval" = mkOption {
                  description = "1s..    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "mac-address" = mkOption {
                  description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)";
                  default = null;
                  type = lib.types.str;
                };
                mtu = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "remote-address" = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                "tunnel-id" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "eoip";
                };
              };
            };
          };
          eoipv6 = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                arp = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "arp-timeout" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "clamp-tcp-mss" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                dscp = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "ipsec-secret" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                keepalive = mkOption {
                  description = "1s..    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "local-address" = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                "loop-protect" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "loop-protect-disable-time" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "loop-protect-send-interval" = mkOption {
                  description = "1s..    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "mac-address" = mkOption {
                  description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)";
                  default = null;
                  type = lib.types.str;
                };
                mtu = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "remote-address" = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                "tunnel-id" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "eoipv6";
                };
              };
            };
          };
          ethernet = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                advertise = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                arp = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "arp-timeout" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "auto-negotiation" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "cable-settings" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "combo-mode" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "disable-running-check" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "fec-mode" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "full-duplex" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                l2mtu = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "loop-protect" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "loop-protect-disable-time" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "loop-protect-send-interval" = mkOption {
                  description = "1s..    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "mac-address" = mkOption {
                  description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)";
                  default = null;
                  type = lib.types.str;
                };
                "mdix-enable" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                mtu = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                "orig-mac-address" = mkOption {
                  description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)";
                  default = null;
                  type = lib.types.str;
                };
                "rx-flow-control" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "sfp-rate-select" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "sfp-shutdown-temperature" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                speed = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "tx-flow-control" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "ethernet";
                };
              };
            };
          };
          gre = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "allow-fast-path" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "clamp-tcp-mss" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "dont-fragment" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                dscp = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "ipsec-secret" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                keepalive = mkOption {
                  description = "1s..    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "local-address" = mkOption {
                  description = "A.B.C.D    (IP address)";
                  default = null;
                  type = lib.types.str;
                };
                mtu = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "remote-address" = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "gre";
                };
              };
            };
          };
          gre6 = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "clamp-tcp-mss" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                dscp = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "ipsec-secret" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                keepalive = mkOption {
                  description = "1s..    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "local-address" = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                mtu = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "remote-address" = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "gre6";
                };
              };
            };
          };
          ipip = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "allow-fast-path" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "clamp-tcp-mss" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "dont-fragment" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                dscp = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "ipsec-secret" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                keepalive = mkOption {
                  description = "1s..    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "local-address" = mkOption {
                  description = "A.B.C.D    (IP address)";
                  default = null;
                  type = lib.types.str;
                };
                mtu = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "remote-address" = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "ipip";
                };
              };
            };
          };
          ipipv6 = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "clamp-tcp-mss" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                dscp = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "ipsec-secret" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                keepalive = mkOption {
                  description = "1s..    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "local-address" = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                mtu = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "remote-address" = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "ipipv6";
                };
              };
            };
          };
          "l2tp-client" = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "add-default-route" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                allow = mkOption {
                  description = "pap|chap|mschap1|mschap2[,Allow*]";
                  default = null;
                  type = lib.types.str;
                };
                "allow-fast-path" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "connect-to" = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "default-route-distance" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "dial-on-demand" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "ipsec-secret" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "keepalive-timeout" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "l2tp-proto-version" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "l2tpv3-circuit-id" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "l2tpv3-cookie-length" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "l2tpv3-digest-hash" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "max-mru" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "max-mtu" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                mrru = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                password = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                profile = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "src-address" = mkOption {
                  description = "A.B.C.D    (IP address)";
                  default = null;
                  type = lib.types.str;
                };
                "use-ipsec" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "use-peer-dns" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                user = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "\"l2tp-client\"";
                };
              };
            };
          };
          "l2tp-ether" = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "allow-fast-path" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "circuit-id" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "connect-to" = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                "cookie-length" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "digest-hash" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "ipsec-secret" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "l2tp-proto-version" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "local-address" = mkOption {
                  description = "A.B.C.D    (IP address)";
                  default = null;
                  type = lib.types.str;
                };
                "local-session-id" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "local-tunnel-id" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "mac-address" = mkOption {
                  description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)";
                  default = null;
                  type = lib.types.str;
                };
                mtu = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "peer-cookie" = mkOption {
                  description = "string value, max length 16";
                  default = null;
                  type = lib.types.str;
                };
                "remote-session-id" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "remote-tunnel-id" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "send-cookie" = mkOption {
                  description = "string value, max length 16";
                  default = null;
                  type = lib.types.str;
                };
                "unmanaged-mode" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "use-ipsec" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "use-l2-specific-sublayer" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "\"l2tp-ether\"";
                };
              };
            };
          };
          "l2tp-server" = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                user = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "\"l2tp-server\"";
                };
              };
            };
          };
          "list" = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                exclude = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                include = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "\"list\"";
                };
              };
            };
          };
          lte = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                "allow-roaming" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "apn-profiles" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                band = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                master = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "modem-init" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                mtu = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "network-mode" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "nr-band" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                operator = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                pin = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "lte";
                };
              };
            };
          };
          macsec = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                cak = mkOption {
                  description = "string value, max length 16";
                  default = null;
                  type = lib.types.str;
                };
                ckn = mkOption {
                  description = "string value, max length 32";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                interface = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                mtu = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                profile = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "macsec";
                };
              };
            };
          };
          mesh = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "admin-mac" = mkOption {
                  description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)";
                  default = null;
                  type = lib.types.str;
                };
                arp = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "arp-timeout" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "auto-mac" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "hwmp-default-hoplimit" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "hwmp-prep-lifetime" = mkOption {
                  description = "..1h    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "hwmp-preq-destination-only" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "hwmp-preq-reply-and-forward" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "hwmp-preq-retries" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "hwmp-preq-waiting-time" = mkOption {
                  description = "1s..30s    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "hwmp-rann-interval" = mkOption {
                  description = "..30m    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "hwmp-rann-lifetime" = mkOption {
                  description = "..1h    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "hwmp-rann-propagation-delay" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "mesh-portal" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                mtu = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "reoptimize-paths" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "mesh";
                };
              };
            };
          };
          "ovpn-client" = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "add-default-route" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                auth = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                certificate = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                cipher = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "connect-to" = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "disconnect-notify" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "mac-address" = mkOption {
                  description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)";
                  default = null;
                  type = lib.types.str;
                };
                "max-mtu" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                mode = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                password = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                port = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                profile = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                protocol = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "route-nopull" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "tls-version" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "use-peer-dns" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                user = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "verify-server-certificate" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "\"ovpn-client\"";
                };
              };
            };
          };
          "ovpn-server" = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                user = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "\"ovpn-server\"";
                };
              };
            };
          };
          "ppp-client" = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "add-default-route" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                allow = mkOption {
                  description = "pap|chap|mschap1|mschap2[,Allow*]";
                  default = null;
                  type = lib.types.str;
                };
                apn = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "data-channel" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "default-route-distance" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "dial-command" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "dial-on-demand" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "info-channel" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "keepalive-timeout" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "max-mru" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "max-mtu" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "modem-init" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                mrru = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "null-modem" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                password = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                phone = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                pin = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                port = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                profile = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "remote-address" = mkOption {
                  description = "A.B.C.D    (IP address)";
                  default = null;
                  type = lib.types.str;
                };
                "use-peer-dns" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                user = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "\"ppp-client\"";
                };
              };
            };
          };
          "ppp-server" = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                authentication = mkOption {
                  description = "pap|chap|mschap1|mschap2[,Authentication*]";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "data-channel" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "max-mru" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "max-mtu" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "modem-init" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                mrru = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "null-modem" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                port = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                profile = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "ring-count" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "\"ppp-server\"";
                };
              };
            };
          };
          "pppoe-client" = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "ac-name" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "add-default-route" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                allow = mkOption {
                  description = "pap|chap|mschap1|mschap2[,Allow*]";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "default-route-distance" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "dial-on-demand" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "host-uniq" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                interface = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "keepalive-timeout" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "max-mru" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "max-mtu" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                mrru = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                password = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                profile = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "service-name" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "use-peer-dns" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                user = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "\"pppoe-client\"";
                };
              };
            };
          };
          "pppoe-server" = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                service = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                user = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "\"pppoe-server\"";
                };
              };
            };
          };
          "pptp-client" = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "add-default-route" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                allow = mkOption {
                  description = "pap|chap|mschap1|mschap2[,Allow*]";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "connect-to" = mkOption {
                  description = "A.B.C.D    (IP address)";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "default-route-distance" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "dial-on-demand" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "keepalive-timeout" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "max-mru" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "max-mtu" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                mrru = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                password = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                profile = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "use-peer-dns" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                user = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "\"pptp-client\"";
                };
              };
            };
          };
          "pptp-server" = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                user = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "\"pptp-server\"";
                };
              };
            };
          };
          "sstp-client" = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "add-default-route" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                authentication = mkOption {
                  description = "pap|chap|mschap1|mschap2[,Authentication*]";
                  default = null;
                  type = lib.types.str;
                };
                certificate = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "connect-to" = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "default-route-distance" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "dial-on-demand" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "http-proxy" = mkOption {
                  description = "A.B.C.D    (IP address)";
                  default = null;
                  type = lib.types.str;
                };
                "keepalive-timeout" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "max-mru" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "max-mtu" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                mrru = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                password = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                pfs = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                port = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                profile = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "proxy-port" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "tls-version" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                user = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "verify-server-address-from-certificate" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "verify-server-certificate" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "\"sstp-client\"";
                };
              };
            };
          };
          "sstp-server" = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                user = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "\"sstp-server\"";
                };
              };
            };
          };
          veth = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                address = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                gateway = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "veth";
                };
              };
            };
          };
          vlan = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                arp = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "arp-timeout" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                interface = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "loop-protect" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "loop-protect-disable-time" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "loop-protect-send-interval" = mkOption {
                  description = "1s..    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                mtu = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "use-service-tag" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "vlan-id" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "vlan";
                };
              };
            };
          };
          vpls = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                arp = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "arp-timeout" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                bridge = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "bridge-cost" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "bridge-horizon" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "cisco-static-id" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "disable-running-check" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "mac-address" = mkOption {
                  description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)";
                  default = null;
                  type = lib.types.str;
                };
                mtu = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                peer = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                "pw-control-word" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "pw-l2mtu" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "pw-type" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "vpls-id" = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "vpls";
                };
              };
            };
          };
          vrrp = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                arp = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "arp-timeout" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                authentication = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "group-master" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                interface = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                interval = mkOption {
                  description = "10ms..4m15s    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                mtu = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "on-backup" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "on-fail" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "on-master" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                password = mkOption {
                  description = "string value, max length 16";
                  default = null;
                  type = lib.types.str;
                };
                "preemption-mode" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                priority = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "remote-address" = mkOption {
                  description = "A.B.C.D    (IP address)";
                  default = null;
                  type = lib.types.str;
                };
                "sync-connection-tracking" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "v3-protocol" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                version = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                vrid = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "vrrp";
                };
              };
            };
          };
          vxlan = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "allow-fast-path" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                arp = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "arp-timeout" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "dont-fragment" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                group = mkOption {
                  description = "A.B.C.D    (IP address)";
                  default = null;
                  type = lib.types.str;
                };
                interface = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "local-address" = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                "loop-protect" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "loop-protect-disable-time" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "loop-protect-send-interval" = mkOption {
                  description = "1s..    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "mac-address" = mkOption {
                  description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)";
                  default = null;
                  type = lib.types.str;
                };
                "max-fdb-size" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                mtu = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                port = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                vni = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                vrf = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "vteps-ip-version" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "vxlan";
                };
              };
            };
          };
          wireguard = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "listen-port" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                mtu = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "private-key" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "wireguard";
                };
              };
            };
          };
          wireless = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "adaptive-noise-immunity" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "allow-sharedkey" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "ampdu-priorities" = mkOption {
                  description = "0|1|2|3|4|5|6|7[,AmpduPriorities*]";
                  default = null;
                  type = lib.types.str;
                };
                "amsdu-limit" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "amsdu-threshold" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "antenna-gain" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "antenna-mode" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                area = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                arp = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "arp-timeout" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                band = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "basic-rates-a/g" = mkOption {
                  description = "6Mbps|9Mbps|12Mbps|18Mbps|24Mbps|36Mbps|48Mbps|54Mbps[,BasicRatesAG*]";
                  default = null;
                  type = lib.types.str;
                };
                "basic-rates-b" = mkOption {
                  description = "1Mbps|2Mbps|5.5Mbps|11Mbps[,BasicRatesB*]";
                  default = null;
                  type = lib.types.str;
                };
                "bridge-mode" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "burst-time" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "channel-width" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                compression = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                country = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "default-ap-tx-limit" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "default-authentication" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "default-client-tx-limit" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "default-forwarding" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "disable-running-check" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "disconnect-timeout" = mkOption {
                  description = "0s..15s    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                distance = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "frame-lifetime" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                frequency = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "frequency-mode" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "frequency-offset" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "guard-interval" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "hide-ssid" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "ht-basic-mcs" = mkOption {
                  description = "mcs-0|mcs-1|mcs-2|mcs-3|mcs-4|mcs-5|mcs-6|mcs-7|mcs-8|mcs-9|mcs-10|mcs-11|mcs-12|mcs-13|mcs-14|mcs-15|mcs-16|mcs-17|mcs-18|mcs-19|mcs-20|mcs-21|mcs-22|mcs-23|mcs-24|mcs-25|mcs-26|mcs-27|mcs-28|mcs-29|mcs-30|mcs-31[,HtBasicMcs*]";
                  default = null;
                  type = lib.types.str;
                };
                "ht-supported-mcs" = mkOption {
                  description = "mcs-0|mcs-1|mcs-2|mcs-3|mcs-4|mcs-5|mcs-6|mcs-7|mcs-8|mcs-9|mcs-10|mcs-11|mcs-12|mcs-13|mcs-14|mcs-15|mcs-16|mcs-17|mcs-18|mcs-19|mcs-20|mcs-21|mcs-22|mcs-23|mcs-24|mcs-25|mcs-26|mcs-27|mcs-28|mcs-29|mcs-30|mcs-31[,HtSupportedMcs*]";
                  default = null;
                  type = lib.types.str;
                };
                "hw-fragmentation-threshold" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "hw-protection-mode" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "hw-protection-threshold" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "hw-retries" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                installation = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "interworking-profile" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "keepalive-frames" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                l2mtu = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "mac-address" = mkOption {
                  description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)";
                  default = null;
                  type = lib.types.str;
                };
                "master-interface" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "max-station-count" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                mode = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                mtu = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "multicast-buffering" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "multicast-helper" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "noise-floor-threshold" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "nv2-cell-radius" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "nv2-downlink-ratio" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "nv2-mode" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "nv2-noise-floor-offset" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "nv2-preshared-key" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "nv2-qos" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "nv2-queue-count" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "nv2-security" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "nv2-sync-secret" = mkOption {
                  description = "string value, max length 32";
                  default = null;
                  type = lib.types.str;
                };
                "on-fail-retry-time" = mkOption {
                  description = "100ms..1s    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "preamble-mode" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "prism-cardtype" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "radio-name" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "rate-selection" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "rate-set" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "rx-chains" = mkOption {
                  description = "0|1|2|3[,RxChains*]";
                  default = null;
                  type = lib.types.str;
                };
                "scan-list" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "secondary-frequency" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "security-profile" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "skip-dfs-channels" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                ssid = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "station-bridge-clone-mac" = mkOption {
                  description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)";
                  default = null;
                  type = lib.types.str;
                };
                "station-roaming" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "supported-rates-a/g" = mkOption {
                  description = "6Mbps|9Mbps|12Mbps|18Mbps|24Mbps|36Mbps|48Mbps|54Mbps[,SupportedRatesAG*]";
                  default = null;
                  type = lib.types.str;
                };
                "supported-rates-b" = mkOption {
                  description = "1Mbps|2Mbps|5.5Mbps|11Mbps[,SupportedRatesB*]";
                  default = null;
                  type = lib.types.str;
                };
                "tdma-period-size" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "tx-chains" = mkOption {
                  description = "0|1|2|3[,TxChains*]";
                  default = null;
                  type = lib.types.str;
                };
                "tx-power" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "tx-power-mode" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "update-stats-interval" = mkOption {
                  description = "10s..5h    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "vht-basic-mcs" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "vht-supported-mcs" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "vlan-id" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "vlan-mode" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "wds-cost-range" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "wds-default-bridge" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "wds-default-cost" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "wds-ignore-ssid" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "wds-mode" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "wireless-protocol" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "wmm-support" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "wps-mode" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "wireless";
                };
              };
            };
          };
        };
      };
    };
    ip = mkOption {
      description = "";
      default = {};
      type = submodule {
        options = {
          address = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                address = mkOption {
                  description = "A.B.C.D    (IP address)";
                  default = null;
                  type = lib.types.str;
                };
                broadcast = mkOption {
                  description = "A.B.C.D    (IP address)";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                interface = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                netmask = mkOption {
                  description = "A.B.C.D    (IP address)";
                  default = null;
                  type = lib.types.str;
                };
                network = mkOption {
                  description = "A.B.C.D    (IP address)";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "address";
                };
              };
            };
          };
          arp = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                address = mkOption {
                  description = "A.B.C.D    (IP address)";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                interface = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "mac-address" = mkOption {
                  description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)";
                  default = null;
                  type = lib.types.str;
                };
                published = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "arp";
                };
              };
            };
          };
          cloud = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                "ddns-enabled" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "ddns-update-interval" = mkOption {
                  description = "1m..    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "update-time" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "cloud";
                };
              };
            };
          };
          "dhcp-client" = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "add-default-route" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "default-route-distance" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "dhcp-options" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                interface = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                script = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "use-peer-dns" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "use-peer-ntp" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "\"dhcp-client\"";
                };
              };
            };
          };
          "dhcp-relay" = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "add-relay-info" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "delay-threshold" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "dhcp-server" = mkOption {
                  description = "A.B.C.D    (IP address)";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                interface = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "local-address" = mkOption {
                  description = "A.B.C.D    (IP address)";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "relay-info-remote-id" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "\"dhcp-relay\"";
                };
              };
            };
          };
          "dhcp-server" = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "add-arp" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "address-pool" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "allow-dual-stack-queue" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "always-broadcast" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                authoritative = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "bootp-lease-time" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "bootp-support" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "client-mac-limit" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "conflict-detection" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "delay-threshold" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "dhcp-option-set" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "insert-queue-before" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                interface = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "lease-script" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "lease-time" = mkOption {
                  description = "1s..    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "parent-queue" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                relay = mkOption {
                  description = "A.B.C.D    (IP address)";
                  default = null;
                  type = lib.types.str;
                };
                "server-address" = mkOption {
                  description = "A.B.C.D    (IP address)";
                  default = null;
                  type = lib.types.str;
                };
                "use-framed-as-classless" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "use-radius" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "\"dhcp-server\"";
                };
              };
            };
          };
          dns = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                "allow-remote-requests" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "cache-max-ttl" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "cache-size" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "doh-max-concurrent-queries" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "doh-max-server-connections" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "doh-timeout" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "max-concurrent-queries" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "max-concurrent-tcp-sessions" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "max-udp-packet-size" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "query-server-timeout" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "query-total-timeout" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                servers = mkOption {
                  description = "A.B.C.D    (IP address)";
                  default = null;
                  type = lib.types.str;
                };
                "use-doh-server" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "verify-doh-cert" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "dns";
                };
              };
            };
          };
          firewall = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                "address-list" = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      address = mkOption {
                        description = "A.B.C.D[-A.B.C.D |0..32 |/A.B.C.D ]    (IP address range)";
                        default = null;
                        type = lib.types.str;
                      };
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      dynamic = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      timeout = mkOption {
                        description = "..35w3d13h13m56s    (time interval)";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "\"address-list\"";
                      };
                    };
                  };
                };
                calea = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      action = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "address-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "address-list-timeout" = mkOption {
                        description = "..35w3d13h13m56s    (time interval)";
                        default = null;
                        type = lib.types.str;
                      };
                      chain = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-bytes" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-limit" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-mark" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-rate" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-type" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      content = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      dscp = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-address" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-address-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-address-type" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-limit" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      fragment = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      hotspot = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "icmp-options" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-bridge-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-bridge-port-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-interface" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-interface-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "ingress-priority" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "ipsec-policy" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "ipv4-options" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "layer7-protocol" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      limit = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      log = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "log-prefix" = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      nth = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-bridge-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-bridge-port-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-interface" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-interface-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "packet-mark" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "packet-size" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "per-connection-classifier" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "place-before" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      port = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      priority = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      protocol = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      psd = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      random = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      realm = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "routing-mark" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "sniff-id" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "sniff-target" = mkOption {
                        description = "A.B.C.D    (IP address)";
                        default = null;
                        type = lib.types.str;
                      };
                      "sniff-target-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-address" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-address-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-address-type" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-mac-address" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "tcp-mss" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      time = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "tls-host" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      ttl = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "calea";
                      };
                    };
                  };
                };
                connection = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                      tracking = mkOption {
                        description = "";
                        default = {};
                        type = submodule {
                          options = {
                            enabled = mkOption {
                              description = "";
                              default = null;
                              type = lib.types.str;
                            };
                            "generic-timeout" = mkOption {
                              description = "time interval";
                              default = null;
                              type = lib.types.str;
                            };
                            "icmp-timeout" = mkOption {
                              description = "time interval";
                              default = null;
                              type = lib.types.str;
                            };
                            "loose-tcp-tracking" = mkOption {
                              description = "";
                              default = null;
                              type = lib.types.str;
                            };
                            "tcp-close-timeout" = mkOption {
                              description = "time interval";
                              default = null;
                              type = lib.types.str;
                            };
                            "tcp-close-wait-timeout" = mkOption {
                              description = "time interval";
                              default = null;
                              type = lib.types.str;
                            };
                            "tcp-established-timeout" = mkOption {
                              description = "time interval";
                              default = null;
                              type = lib.types.str;
                            };
                            "tcp-fin-wait-timeout" = mkOption {
                              description = "time interval";
                              default = null;
                              type = lib.types.str;
                            };
                            "tcp-last-ack-timeout" = mkOption {
                              description = "time interval";
                              default = null;
                              type = lib.types.str;
                            };
                            "tcp-max-retrans-timeout" = mkOption {
                              description = "time interval";
                              default = null;
                              type = lib.types.str;
                            };
                            "tcp-syn-received-timeout" = mkOption {
                              description = "time interval";
                              default = null;
                              type = lib.types.str;
                            };
                            "tcp-syn-sent-timeout" = mkOption {
                              description = "time interval";
                              default = null;
                              type = lib.types.str;
                            };
                            "tcp-time-wait-timeout" = mkOption {
                              description = "time interval";
                              default = null;
                              type = lib.types.str;
                            };
                            "tcp-unacked-timeout" = mkOption {
                              description = "time interval";
                              default = null;
                              type = lib.types.str;
                            };
                            "udp-stream-timeout" = mkOption {
                              description = "time interval";
                              default = null;
                              type = lib.types.str;
                            };
                            "udp-timeout" = mkOption {
                              description = "time interval";
                              default = null;
                              type = lib.types.str;
                            };
                            _create = mkOption {
                              description = "Creation script";
                              internal = true;
                              readOnly = true;
                              type = lib.types.str;
                              default = "# " + "tracking";
                            };
                          };
                        };
                      };
                    };
                  };
                };
                filter = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      action = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "address-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "address-list-timeout" = mkOption {
                        description = "..35w3d13h13m56s    (time interval)";
                        default = null;
                        type = lib.types.str;
                      };
                      chain = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-bytes" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-limit" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-mark" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-nat-state" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-rate" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-state" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-type" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      content = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      dscp = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-address" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-address-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-address-type" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-limit" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      fragment = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      hotspot = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "hw-offload" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "icmp-options" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-bridge-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-bridge-port-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-interface" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-interface-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "ingress-priority" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "ipsec-policy" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "ipv4-options" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "jump-target" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "layer7-protocol" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      limit = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      log = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "log-prefix" = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      nth = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-bridge-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-bridge-port-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-interface" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-interface-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      p2p = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "packet-mark" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "packet-size" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "per-connection-classifier" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "place-before" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      port = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      priority = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      protocol = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      psd = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      random = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      realm = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "reject-with" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "routing-mark" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-address" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-address-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-address-type" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-mac-address" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "tcp-flags" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "tcp-mss" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      time = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "tls-host" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      ttl = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "filter";
                      };
                    };
                  };
                };
                "layer7-protocol" = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      name = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      regexp = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "\"layer7-protocol\"";
                      };
                    };
                  };
                };
                mangle = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      action = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "address-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "address-list-timeout" = mkOption {
                        description = "..35w3d13h13m56s    (time interval)";
                        default = null;
                        type = lib.types.str;
                      };
                      chain = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-bytes" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-limit" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-mark" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-nat-state" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-rate" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-state" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-type" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      content = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      dscp = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-address" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-address-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-address-type" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-limit" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      fragment = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      hotspot = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "icmp-options" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-bridge-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-bridge-port-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-interface" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-interface-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "ingress-priority" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "ipsec-policy" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "ipv4-options" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "jump-target" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "layer7-protocol" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      limit = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      log = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "log-prefix" = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "new-connection-mark" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "new-dscp" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "new-mss" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "new-packet-mark" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "new-priority" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "new-routing-mark" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "new-ttl" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      nth = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-bridge-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-bridge-port-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-interface" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-interface-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      p2p = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "packet-mark" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "packet-size" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      passthrough = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "per-connection-classifier" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "place-before" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      port = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      priority = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      protocol = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      psd = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      random = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      realm = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "route-dst" = mkOption {
                        description = "A.B.C.D    (IP address)";
                        default = null;
                        type = lib.types.str;
                      };
                      "routing-mark" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "sniff-id" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "sniff-target" = mkOption {
                        description = "A.B.C.D    (IP address)";
                        default = null;
                        type = lib.types.str;
                      };
                      "sniff-target-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-address" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-address-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-address-type" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-mac-address" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "tcp-flags" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "tcp-mss" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      time = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "tls-host" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      ttl = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "mangle";
                      };
                    };
                  };
                };
                nat = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      action = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "address-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "address-list-timeout" = mkOption {
                        description = "..35w3d13h13m56s    (time interval)";
                        default = null;
                        type = lib.types.str;
                      };
                      chain = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-bytes" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-limit" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-mark" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-rate" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-type" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      content = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      dscp = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-address" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-address-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-address-type" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-limit" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      fragment = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      hotspot = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "icmp-options" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-bridge-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-bridge-port-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-interface" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-interface-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "ingress-priority" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "ipsec-policy" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "ipv4-options" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "jump-target" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "layer7-protocol" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      limit = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      log = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "log-prefix" = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      nth = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-bridge-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-bridge-port-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-interface" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-interface-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "packet-mark" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "packet-size" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "per-connection-classifier" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "place-before" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      port = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      priority = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      protocol = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      psd = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      random = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      realm = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "routing-mark" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "same-not-by-dst" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-address" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-address-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-address-type" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-mac-address" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "tcp-mss" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      time = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "tls-host" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "to-addresses" = mkOption {
                        description = "A.B.C.D[-A.B.C.D |0..32 |/A.B.C.D ]    (IP address range)";
                        default = null;
                        type = lib.types.str;
                      };
                      "to-ports" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      ttl = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "nat";
                      };
                    };
                  };
                };
                raw = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      action = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "address-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "address-list-timeout" = mkOption {
                        description = "..35w3d13h13m56s    (time interval)";
                        default = null;
                        type = lib.types.str;
                      };
                      chain = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      content = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      dscp = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-address" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-address-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-address-type" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-limit" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      fragment = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      hotspot = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "icmp-options" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-bridge-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-bridge-port-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-interface" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-interface-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "ingress-priority" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "ipsec-policy" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "ipv4-options" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "jump-target" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      limit = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      log = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "log-prefix" = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      nth = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-bridge-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-bridge-port-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-interface" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-interface-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "packet-mark" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "packet-size" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "per-connection-classifier" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "place-before" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      port = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      priority = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      protocol = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      psd = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      random = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-address" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-address-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-address-type" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-mac-address" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "tcp-flags" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "tcp-mss" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      time = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "tls-host" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      ttl = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "raw";
                      };
                    };
                  };
                };
                "service-port" = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      ports = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "sip-direct-media" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "sip-timeout" = mkOption {
                        description = "time interval";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "\"service-port\"";
                      };
                    };
                  };
                };
              };
            };
          };
          hotspot = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "address-pool" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "addresses-per-mac" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "idle-timeout" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                interface = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "keepalive-timeout" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "login-timeout" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                profile = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "hotspot";
                };
              };
            };
          };
          ipsec = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                "active-peers" = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "\"active-peers\"";
                      };
                    };
                  };
                };
                identity = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      "auth-method" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      certificate = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      "eap-methods" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "generate-policy" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      key = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "match-by" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "mode-config" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "my-id" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "notrack-chain" = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      password = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      peer = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "policy-template-group" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "remote-certificate" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "remote-id" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "remote-key" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      secret = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      username = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "identity";
                      };
                    };
                  };
                };
                "installed-sa" = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                    };
                  };
                };
                key = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                      name = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "key";
                      };
                    };
                  };
                };
                "mode-config" = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      address = mkOption {
                        description = "A.B.C.D    (IP address)";
                        default = null;
                        type = lib.types.str;
                      };
                      "address-pool" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "address-prefix-length" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-mark" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      name = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      responder = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "split-dns" = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "split-include" = mkOption {
                        description = "A.B.C.D/M    (IP prefix)";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-address-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "static-dns" = mkOption {
                        description = "A.B.C.D    (IP address)";
                        default = null;
                        type = lib.types.str;
                      };
                      "system-dns" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "use-responder-dns" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "see documentation";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "\"mode-config\"";
                      };
                    };
                  };
                };
                peer = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      address = mkOption {
                        description = "IPv6/0..128    (IPv6 prefix)";
                        default = null;
                        type = lib.types.str;
                      };
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      "exchange-mode" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "local-address" = mkOption {
                        description = "see documentation";
                        default = null;
                        type = lib.types.str;
                      };
                      name = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      passive = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      port = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      profile = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "send-initial-contact" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "peer";
                      };
                    };
                  };
                };
                policy = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      action = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-address" = mkOption {
                        description = "IPv6/0..128    (IPv6 prefix)";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      group = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "ipsec-protocols" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      level = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      peer = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "place-before" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      proposal = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      protocol = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "sa-dst-address" = mkOption {
                        description = "see documentation";
                        default = null;
                        type = lib.types.str;
                      };
                      "sa-src-address" = mkOption {
                        description = "see documentation";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-address" = mkOption {
                        description = "IPv6/0..128    (IPv6 prefix)";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      template = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      tunnel = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "policy";
                      };
                    };
                  };
                };
                profile = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dh-group" = mkOption {
                        description = "x25519|ecp256|ecp384|ecp521|ec2n185|ec2n155|modp8192|modp6144|modp4096|modp3072|modp2048|modp1536|modp1024|modp768[,DhGroup*]";
                        default = null;
                        type = lib.types.str;
                      };
                      "dpd-interval" = mkOption {
                        description = "..1h    (time interval)";
                        default = null;
                        type = lib.types.str;
                      };
                      "dpd-maximum-failures" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "enc-algorithm" = mkOption {
                        description = "aes-256|aes-192|aes-128|3des|des[,EncAlgorithm*]";
                        default = null;
                        type = lib.types.str;
                      };
                      "hash-algorithm" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      lifebytes = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      lifetime = mkOption {
                        description = "time interval";
                        default = null;
                        type = lib.types.str;
                      };
                      name = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "nat-traversal" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "prf-algorithm" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "proposal-check" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "see documentation";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "profile";
                      };
                    };
                  };
                };
                proposal = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      "auth-algorithms" = mkOption {
                        description = "sha512|sha256|sha1|md5|null[,AuthAlgorithms*]";
                        default = null;
                        type = lib.types.str;
                      };
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      "enc-algorithms" = mkOption {
                        description = "chacha20poly1305|aes-256-cbc|aes-256-ctr|aes-256-gcm|camellia-256|aes-192-cbc|aes-192-ctr|aes-192-gcm|camellia-192|aes-128-cbc|aes-128-ctr|aes-128-gcm|camellia-128|3des|blowfish|twofish|des|null[,EncAlgorithms*]";
                        default = null;
                        type = lib.types.str;
                      };
                      lifetime = mkOption {
                        description = "time interval";
                        default = null;
                        type = lib.types.str;
                      };
                      name = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "pfs-group" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "see documentation";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "proposal";
                      };
                    };
                  };
                };
                settings = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                      accounting = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "interim-update" = mkOption {
                        description = "time interval";
                        default = null;
                        type = lib.types.str;
                      };
                      "xauth-use-radius" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "settings";
                      };
                    };
                  };
                };
                statistics = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                    };
                  };
                };
              };
            };
          };
          "kid-control" = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                fri = mkOption {
                  description = "0s..1d    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                mon = mkOption {
                  description = "0s..1d    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "rate-limit" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                sat = mkOption {
                  description = "0s..1d    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                sun = mkOption {
                  description = "0s..1d    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                thu = mkOption {
                  description = "0s..1d    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                tue = mkOption {
                  description = "0s..1d    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "tur-fri" = mkOption {
                  description = "0s..1d    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "tur-mon" = mkOption {
                  description = "0s..1d    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "tur-sat" = mkOption {
                  description = "0s..1d    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "tur-sun" = mkOption {
                  description = "0s..1d    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "tur-thu" = mkOption {
                  description = "0s..1d    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "tur-tue" = mkOption {
                  description = "0s..1d    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "tur-wed" = mkOption {
                  description = "0s..1d    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                wed = mkOption {
                  description = "0s..1d    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "\"kid-control\"";
                };
              };
            };
          };
          neighbor = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                "discovery-settings" = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                      "discover-interface-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "lldp-med-net-policy-vlan" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      mode = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      protocol = mkOption {
                        description = "cdp|lldp|mndp[,Protocol*]";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "\"discovery-settings\"";
                      };
                    };
                  };
                };
              };
            };
          };
          packing = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "aggregated-size" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                interface = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                packing = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                unpacking = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "packing";
                };
              };
            };
          };
          pool = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "next-pool" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                ranges = mkOption {
                  description = "A.B.C.D[-A.B.C.D |0..32 |/A.B.C.D ]    (IP address range)";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "pool";
                };
              };
            };
          };
          proxy = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                "always-from-cache" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                anonymous = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "cache-administrator" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "cache-hit-dscp" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "cache-on-disk" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "cache-path" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                enabled = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "max-cache-object-size" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "max-cache-size" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "max-client-connections" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "max-fresh-time" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "max-server-connections" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "parent-proxy" = mkOption {
                  description = "A.B.C.D    (IP address)";
                  default = null;
                  type = lib.types.str;
                };
                "parent-proxy-port" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                port = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "serialize-connections" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "src-address" = mkOption {
                  description = "A.B.C.D    (IP address)";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "proxy";
                };
              };
            };
          };
          route = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                blackhole = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "check-gateway" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                distance = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "dst-address" = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                gateway = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                "pref-src" = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                "routing-table" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                scope = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "suppress-hw-offload" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "target-scope" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "vrf-interface" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "route";
                };
              };
            };
          };
          service = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                address = mkOption {
                  description = "A.B.C.D/M    (IP prefix)";
                  default = null;
                  type = lib.types.str;
                };
                certificate = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                port = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "tls-version" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                vrf = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "service";
                };
              };
            };
          };
          settings = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                "accept-redirects" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "accept-source-route" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "allow-fast-path" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "arp-timeout" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "icmp-rate-limit" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "icmp-rate-mask" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "ip-forward" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "max-neighbor-entries" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "route-cache" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "rp-filter" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "secure-redirects" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "send-redirects" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "tcp-syncookies" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "settings";
                };
              };
            };
          };
          smb = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                "allow-guests" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                domain = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                enabled = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                interfaces = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "smb";
                };
              };
            };
          };
          socks = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                "auth-method" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "connection-idle-timeout" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                enabled = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "max-connections" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                port = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                version = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                vrf = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "socks";
                };
              };
            };
          };
          ssh = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                "allow-none-crypto" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "always-allow-password-login" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "forwarding-enabled" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "host-key-size" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "host-key-type" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "strong-crypto" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "ssh";
                };
              };
            };
          };
          tftp = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                allow = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "allow-overwrite" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "allow-rollover" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "ip-addresses" = mkOption {
                  description = "IPv6/0..128    (IPv6 prefix)";
                  default = null;
                  type = lib.types.str;
                };
                "place-before" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "read-only" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "reading-window-size" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "real-filename" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "req-filename" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "tftp";
                };
              };
            };
          };
          "traffic-flow" = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                "active-flow-timeout" = mkOption {
                  description = "1s..    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "cache-entries" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enabled = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "inactive-flow-timeout" = mkOption {
                  description = "1s..    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                interfaces = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "packet-sampling" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "sampling-interval" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "sampling-space" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "\"traffic-flow\"";
                };
              };
            };
          };
          upnp = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                "allow-disable-external-interface" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enabled = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "show-dummy-rule" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "upnp";
                };
              };
            };
          };
          vrf = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                interfaces = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "place-before" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "vrf";
                };
              };
            };
          };
        };
      };
    };
    ipv6 = mkOption {
      description = "";
      default = {};
      type = submodule {
        options = {
          address = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                address = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                advertise = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "eui-64" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "from-pool" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                interface = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "no-dad" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "address";
                };
              };
            };
          };
          "dhcp-client" = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "add-default-route" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "default-route-distance" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "dhcp-options" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                interface = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "pool-name" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "pool-prefix-length" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "prefix-hint" = mkOption {
                  description = "IPv6/0..128    (IPv6 prefix)";
                  default = null;
                  type = lib.types.str;
                };
                "rapid-commit" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                request = mkOption {
                  description = "info|address|prefix[,Request*]";
                  default = null;
                  type = lib.types.str;
                };
                script = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "use-interface-duid" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "use-peer-dns" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "\"dhcp-client\"";
                };
              };
            };
          };
          "dhcp-relay" = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "delay-threshold" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "dhcp-server" = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                interface = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "link-address" = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "\"dhcp-relay\"";
                };
              };
            };
          };
          "dhcp-server" = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "address-pool" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "allow-dual-stack-queue" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "binding-script" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "dhcp-option" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "insert-queue-before" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                interface = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "lease-time" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "parent-queue" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                preference = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "rapid-commit" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "route-distance" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "use-radius" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "\"dhcp-server\"";
                };
              };
            };
          };
          firewall = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                "address-list" = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      address = mkOption {
                        description = "IPv6/0..128    (IPv6 prefix)";
                        default = null;
                        type = lib.types.str;
                      };
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      dynamic = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      timeout = mkOption {
                        description = "time interval";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "\"address-list\"";
                      };
                    };
                  };
                };
                connection = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                    };
                  };
                };
                filter = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      action = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "address-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "address-list-timeout" = mkOption {
                        description = "time interval";
                        default = null;
                        type = lib.types.str;
                      };
                      chain = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-bytes" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-limit" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-mark" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-nat-state" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-rate" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-state" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-type" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      content = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      dscp = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-address" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-address-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-address-type" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-limit" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      headers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "hop-limit" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "icmp-options" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-bridge-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-bridge-port-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-interface" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-interface-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "ingress-priority" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "ipsec-policy" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "jump-target" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      limit = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      log = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "log-prefix" = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      nth = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-bridge-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-bridge-port-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-interface" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-interface-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "packet-mark" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "packet-size" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "per-connection-classifier" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "place-before" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      port = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      priority = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      protocol = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      random = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "reject-with" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "routing-mark" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-address" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-address-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-address-type" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-mac-address" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "tcp-flags" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "tcp-mss" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      time = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "tls-host" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "filter";
                      };
                    };
                  };
                };
                mangle = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      action = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "address-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "address-list-timeout" = mkOption {
                        description = "time interval";
                        default = null;
                        type = lib.types.str;
                      };
                      chain = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-bytes" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-limit" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-mark" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-nat-state" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-rate" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-state" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-type" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      content = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      dscp = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-address" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-address-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-address-type" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-limit" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-prefix" = mkOption {
                        description = "IPv6/0..128    (IPv6 prefix)";
                        default = null;
                        type = lib.types.str;
                      };
                      headers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "hop-limit" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "icmp-options" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-bridge-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-bridge-port-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-interface" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-interface-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "ingress-priority" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "ipsec-policy" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "jump-target" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      limit = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      log = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "log-prefix" = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "new-connection-mark" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "new-dscp" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "new-hop-limit" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "new-mss" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "new-packet-mark" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "new-priority" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "new-routing-mark" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      nth = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-bridge-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-bridge-port-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-interface" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-interface-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "packet-mark" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "packet-size" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      passthrough = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "per-connection-classifier" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "place-before" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      port = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      priority = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      protocol = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      random = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "routing-mark" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "sniff-id" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "sniff-target" = mkOption {
                        description = "A.B.C.D    (IP address)";
                        default = null;
                        type = lib.types.str;
                      };
                      "sniff-target-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-address" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-address-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-address-type" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-mac-address" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-prefix" = mkOption {
                        description = "IPv6/0..128    (IPv6 prefix)";
                        default = null;
                        type = lib.types.str;
                      };
                      "tcp-flags" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "tcp-mss" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      time = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "tls-host" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "mangle";
                      };
                    };
                  };
                };
                nat = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      action = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "address-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "address-list-timeout" = mkOption {
                        description = "time interval";
                        default = null;
                        type = lib.types.str;
                      };
                      chain = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-bytes" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-limit" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-mark" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-rate" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-state" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "connection-type" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      content = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      dscp = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-address" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-address-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-address-type" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-limit" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      headers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "hop-limit" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "icmp-options" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-bridge-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-bridge-port-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-interface" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-interface-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "ingress-priority" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "ipsec-policy" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "jump-target" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      limit = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      log = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "log-prefix" = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      nth = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-bridge-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-bridge-port-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-interface" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-interface-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "packet-mark" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "packet-size" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "per-connection-classifier" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "place-before" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      port = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      priority = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      protocol = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      random = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "routing-mark" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-address" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-address-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-address-type" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-mac-address" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "tcp-flags" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "tcp-mss" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      time = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "tls-host" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "to-address" = mkOption {
                        description = "IPv6/0..128    (IPv6 prefix)";
                        default = null;
                        type = lib.types.str;
                      };
                      "to-ports" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "nat";
                      };
                    };
                  };
                };
                raw = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      action = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "address-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "address-list-timeout" = mkOption {
                        description = "time interval";
                        default = null;
                        type = lib.types.str;
                      };
                      chain = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      content = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      dscp = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-address" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-address-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-address-type" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-limit" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dst-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      headers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "hop-limit" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "icmp-options" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-bridge-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-bridge-port-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-interface" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-interface-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "ingress-priority" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "ipsec-policy" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "jump-target" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      limit = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      log = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "log-prefix" = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      nth = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-bridge-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-bridge-port-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-interface" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-interface-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "packet-mark" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "packet-size" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "per-connection-classifier" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "place-before" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      port = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      priority = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      protocol = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      random = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-address" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-address-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-address-type" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-mac-address" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "src-port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "tcp-flags" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "tcp-mss" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      time = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "tls-host" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "raw";
                      };
                    };
                  };
                };
              };
            };
          };
          nd = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "advertise-dns" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "advertise-mac-address" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                dns = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                "hop-limit" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                interface = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "managed-address-configuration" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                mtu = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "other-configuration" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                pref64 = mkOption {
                  description = "IPv6/0..128    (IPv6 prefix)";
                  default = null;
                  type = lib.types.str;
                };
                "ra-delay" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "ra-interval" = mkOption {
                  description = "3s..20m50s    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "ra-lifetime" = mkOption {
                  description = "..2h30m    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "ra-preference" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "reachable-time" = mkOption {
                  description = "..1h    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "retransmit-interval" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "nd";
                };
              };
            };
          };
          neighbor = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
              };
            };
          };
          pool = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                prefix = mkOption {
                  description = "IPv6/0..128    (IPv6 prefix)";
                  default = null;
                  type = lib.types.str;
                };
                "prefix-length" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "pool";
                };
              };
            };
          };
          route = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                blackhole = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "check-gateway" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                distance = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "dst-address" = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                gateway = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                "routing-table" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                scope = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "target-scope" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "vrf-interface" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "route";
                };
              };
            };
          };
          settings = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                "accept-redirects" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "accept-router-advertisements" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "disable-ipv6" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                forward = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "max-neighbor-entries" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "settings";
                };
              };
            };
          };
        };
      };
    };
    log = mkOption {
      description = "";
      default = {};
      type = submodule {
        options = {
        };
      };
    };
    mpls = mkOption {
      description = "";
      default = {};
      type = submodule {
        options = {
          "forwarding-table" = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
              };
            };
          };
          interface = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                input = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                interface = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "mpls-mtu" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "place-before" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "interface";
                };
              };
            };
          };
          ldp = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                afi = mkOption {
                  description = "ip|ipv6[,Afi*]";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "distribute-for-default" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "hop-limit" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "loop-detect" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "lsr-id" = mkOption {
                  description = "A.B.C.D    (IP address)";
                  default = null;
                  type = lib.types.str;
                };
                "path-vector-limit" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "preferred-afi" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "transport-addresses" = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                "use-explicit-null" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                vrf = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "ldp";
                };
              };
            };
          };
          "traffic-eng" = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                flow = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                    };
                  };
                };
                interface = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      bandwidth = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "blockade-k-factor" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      "down-flood-thresholds" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "igp-flood-period" = mkOption {
                        description = "time interval";
                        default = null;
                        type = lib.types.str;
                      };
                      interface = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "k-factor" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "refresh-time" = mkOption {
                        description = "time interval";
                        default = null;
                        type = lib.types.str;
                      };
                      "resource-class" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "te-metric" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "up-flood-thresholds" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "use-udp" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "interface";
                      };
                    };
                  };
                };
                path = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      "affinity-exclude" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "affinity-include-all" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "affinity-include-any" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      "holding-priority" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      hops = mkOption {
                        description = "see documentation";
                        default = null;
                        type = lib.types.str;
                      };
                      name = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "record-route" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "reoptimize-interval" = mkOption {
                        description = "time interval";
                        default = null;
                        type = lib.types.str;
                      };
                      "setup-priority" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "use-cspf" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "path";
                      };
                    };
                  };
                };
                tunnel = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      "affinity-exclude" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "affinity-include-all" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "affinity-include-any" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "auto-bandwidth-avg-interval" = mkOption {
                        description = "1s..    (time interval)";
                        default = null;
                        type = lib.types.str;
                      };
                      "auto-bandwidth-range" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "auto-bandwidth-reserve" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "auto-bandwidth-update-interval" = mkOption {
                        description = "1m..    (time interval)";
                        default = null;
                        type = lib.types.str;
                      };
                      bandwidth = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "bandwidth-limit" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      "from-address" = mkOption {
                        description = "see documentation";
                        default = null;
                        type = lib.types.str;
                      };
                      "holding-priority" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      name = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "primary-path" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "primary-retry-interval" = mkOption {
                        description = "time interval";
                        default = null;
                        type = lib.types.str;
                      };
                      "record-route" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "reoptimize-interval" = mkOption {
                        description = "time interval";
                        default = null;
                        type = lib.types.str;
                      };
                      "secondary-paths" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "secondary-standby" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "setup-priority" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "to-address" = mkOption {
                        description = "see documentation";
                        default = null;
                        type = lib.types.str;
                      };
                      vrf = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "tunnel";
                      };
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
    port = mkOption {
      description = "";
      default = {};
      type = submodule {
        options = {
          "baud-rate" = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          "data-bits" = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          dtr = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          "flow-control" = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          name = mkOption {
            description = "string value";
            default = null;
            type = lib.types.str;
          };
          numbers = mkOption {
            description = "see documentation";
            default = null;
            type = lib.types.str;
          };
          parity = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          rts = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          "stop-bits" = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          _create = mkOption {
            description = "Creation script";
            internal = true;
            readOnly = true;
            type = lib.types.str;
            default = "# " + "port";
          };
        };
      };
    };
    ppp = mkOption {
      description = "";
      default = {};
      type = submodule {
        options = {
          aaa = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                accounting = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "interim-update" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "use-circuit-id-in-nas-port-id" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "use-radius" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "aaa";
                };
              };
            };
          };
          active = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
              };
            };
          };
          "l2tp-secret" = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                address = mkOption {
                  description = "A.B.C.D/M    (IP prefix)";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                secret = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "\"l2tp-secret\"";
                };
              };
            };
          };
          profile = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "address-list" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                bridge = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "bridge-horizon" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "bridge-learning" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "bridge-path-cost" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "bridge-port-priority" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "change-tcp-mss" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "dhcpv6-pd-pool" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "dns-server" = mkOption {
                  description = "A.B.C.D    (IP address)";
                  default = null;
                  type = lib.types.str;
                };
                "idle-timeout" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "incoming-filter" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "insert-queue-before" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "interface-list" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "local-address" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "on-down" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "on-up" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "only-one" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "outgoing-filter" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "parent-queue" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "queue-type" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "rate-limit" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "remote-address" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "remote-ipv6-prefix-pool" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "session-timeout" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "use-compression" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "use-encryption" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "use-ipv6" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "use-mpls" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "use-upnp" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "wins-server" = mkOption {
                  description = "A.B.C.D    (IP address)";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "profile";
                };
              };
            };
          };
          secret = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "caller-id" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "ipv6-routes" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "limit-bytes-in" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "limit-bytes-out" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "local-address" = mkOption {
                  description = "A.B.C.D    (IP address)";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value, min length 1";
                  default = null;
                  type = lib.types.str;
                };
                password = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                profile = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "remote-address" = mkOption {
                  description = "A.B.C.D    (IP address)";
                  default = null;
                  type = lib.types.str;
                };
                "remote-ipv6-prefix" = mkOption {
                  description = "IPv6/0..128    (IPv6 prefix)";
                  default = null;
                  type = lib.types.str;
                };
                routes = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                service = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "secret";
                };
              };
            };
          };
        };
      };
    };
    queue = mkOption {
      description = "";
      default = {};
      type = submodule {
        options = {
          interface = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                numbers = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                queue = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "interface";
                };
              };
            };
          };
          simple = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "bucket-size" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "burst-limit" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "burst-threshold" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "burst-time" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                dst = mkOption {
                  description = "A.B.C.D/M    (IP prefix)";
                  default = null;
                  type = lib.types.str;
                };
                "limit-at" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "max-limit" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "packet-marks" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                parent = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "place-before" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                priority = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                queue = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                target = mkOption {
                  description = "A.B.C.D/M    (IP prefix)";
                  default = null;
                  type = lib.types.str;
                };
                time = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "total-bucket-size" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "total-burst-limit" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "total-burst-threshold" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "total-burst-time" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "total-limit-at" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "total-max-limit" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "total-priority" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "total-queue" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "simple";
                };
              };
            };
          };
          tree = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "bucket-size" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "burst-limit" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "burst-threshold" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "burst-time" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "limit-at" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "max-limit" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "packet-mark" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                parent = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                priority = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                queue = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "tree";
                };
              };
            };
          };
          type = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "bfifo-limit" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "cake-ack-filter" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "cake-atm" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "cake-autorate-ingress" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "cake-bandwidth" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "cake-diffserv" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "cake-flowmode" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "cake-memlimit" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "cake-mpu" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "cake-nat" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "cake-overhead" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "cake-overhead-scheme" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "cake-rtt" = mkOption {
                  description = "0s..7101w3d6h28m15s    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "cake-rtt-scheme" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "cake-wash" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "codel-ce-threshold" = mkOption {
                  description = "0s..7101w3d6h28m15s    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "codel-ecn" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "codel-interval" = mkOption {
                  description = "0s..7101w3d6h28m15s    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "codel-limit" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "codel-target" = mkOption {
                  description = "0s..7101w3d6h28m15s    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "fq-codel-ce-threshold" = mkOption {
                  description = "0s..7101w3d6h28m15s    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "fq-codel-ecn" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "fq-codel-flows" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "fq-codel-interval" = mkOption {
                  description = "0s..7101w3d6h28m15s    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "fq-codel-limit" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "fq-codel-memlimit" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "fq-codel-quantum" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "fq-codel-target" = mkOption {
                  description = "0s..7101w3d6h28m15s    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                kind = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "mq-pfifo-limit" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "pcq-burst-rate" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "pcq-burst-threshold" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "pcq-burst-time" = mkOption {
                  description = "1s..    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "pcq-classifier" = mkOption {
                  description = "src-address|dst-address|src-port|dst-port[,PcqClassifier*]";
                  default = null;
                  type = lib.types.str;
                };
                "pcq-dst-address-mask" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "pcq-dst-address6-mask" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "pcq-limit" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "pcq-rate" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "pcq-src-address-mask" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "pcq-src-address6-mask" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "pcq-total-limit" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "pfifo-limit" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "red-avg-packet" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "red-burst" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "red-limit" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "red-max-threshold" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "red-min-threshold" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "sfq-allot" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "sfq-perturb" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "type";
                };
              };
            };
          };
        };
      };
    };
    radius = mkOption {
      description = "";
      default = {};
      type = attrsOf submodule {
        options = {
          "accounting-backup" = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          "accounting-port" = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          address = mkOption {
            description = "see documentation";
            default = null;
            type = lib.types.str;
          };
          "authentication-port" = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          "called-id" = mkOption {
            description = "string value";
            default = null;
            type = lib.types.str;
          };
          certificate = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          comment = mkOption {
            description = "string value";
            default = null;
            type = lib.types.str;
          };
          "copy-from" = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          enable = mkOption {
            description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
            default = null;
            type = lib.types.str;
          };
          domain = mkOption {
            description = "string value";
            default = null;
            type = lib.types.str;
          };
          "place-before" = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          protocol = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          realm = mkOption {
            description = "string value";
            default = null;
            type = lib.types.str;
          };
          secret = mkOption {
            description = "string value";
            default = null;
            type = lib.types.str;
          };
          service = mkOption {
            description = "ppp|login|hotspot|wireless|dhcp|ipsec|dot1x[,Service*]";
            default = null;
            type = lib.types.str;
          };
          "src-address" = mkOption {
            description = "A.B.C.D    (IP address)";
            default = null;
            type = lib.types.str;
          };
          timeout = mkOption {
            description = "10ms..1m    (time interval)";
            default = null;
            type = lib.types.str;
          };
          numbers = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          _create = mkOption {
            description = "Creation script";
            internal = true;
            readOnly = true;
            type = lib.types.str;
            default = "# " + "radius";
          };
        };
      };
    };
    routing = mkOption {
      description = "";
      default = {};
      type = submodule {
        options = {
          bgp = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                advertisements = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                    };
                  };
                };
                connection = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      "add-path-out" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "address-families" = mkOption {
                        description = "ip|ipv6|l2vpn|l2vpn-cisco|vpnv4[,AddressFamilies*]";
                        default = null;
                        type = lib.types.str;
                      };
                      as = mkOption {
                        description = "0..4294967295";
                        default = null;
                        type = lib.types.str;
                      };
                      "as-override" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "cisco-vpls-nlri-len-fmt" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "cluster-id" = mkOption {
                        description = "A.B.C.D    (IP address)";
                        default = null;
                        type = lib.types.str;
                      };
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      connect = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      "hold-time" = mkOption {
                        description = "3s..1h    (time interval)";
                        default = null;
                        type = lib.types.str;
                      };
                      "input.accept-communities" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "input.accept-ext-communities" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "input.accept-large-communities" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "input.accept-nlri" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "input.accept-unknown" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "input.affinity" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "input.allow-as" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "input.filter" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "input.ignore-as-path-len" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "input.limit-process-routes-ipv4" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "input.limit-process-routes-ipv6" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "keepalive-time" = mkOption {
                        description = "1s..30m    (time interval)";
                        default = null;
                        type = lib.types.str;
                      };
                      listen = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "local.address" = mkOption {
                        description = "see documentation";
                        default = null;
                        type = lib.types.str;
                      };
                      "local.port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "local.role" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "local.ttl" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      multihop = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      name = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "nexthop-choice" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "output.affinity" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "output.default-originate" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "output.default-prepend" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "output.filter-chain" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "output.filter-select" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "output.keep-sent-attributes" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "output.network" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "output.no-client-to-client-reflection" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "output.no-early-cut" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "output.redistribute" = mkOption {
                        description = "connected|static|rip|ospf|bgp|vpn|dhcp|fantasy|modem|bgp-mpls-vpn[,OutputRedistribute*]";
                        default = null;
                        type = lib.types.str;
                      };
                      "remote.address" = mkOption {
                        description = "see documentation";
                        default = null;
                        type = lib.types.str;
                      };
                      "remote.allowed-as" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "remote.as" = mkOption {
                        description = "0..4294967295";
                        default = null;
                        type = lib.types.str;
                      };
                      "remote.port" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "remote.ttl" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "remove-private-as" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "router-id" = mkOption {
                        description = "A.B.C.D    (IP address)";
                        default = null;
                        type = lib.types.str;
                      };
                      "routing-table" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "save-to" = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "tcp-md5-key" = mkOption {
                        description = "string value, max length 80";
                        default = null;
                        type = lib.types.str;
                      };
                      templates = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "use-bfd" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      vrf = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "connection";
                      };
                    };
                  };
                };
                session = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                    };
                  };
                };
                template = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      "add-path-out" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "address-families" = mkOption {
                        description = "ip|ipv6|l2vpn|l2vpn-cisco|vpnv4[,AddressFamilies*]";
                        default = null;
                        type = lib.types.str;
                      };
                      as = mkOption {
                        description = "0..4294967295";
                        default = null;
                        type = lib.types.str;
                      };
                      "as-override" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "cisco-vpls-nlri-len-fmt" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "cluster-id" = mkOption {
                        description = "A.B.C.D    (IP address)";
                        default = null;
                        type = lib.types.str;
                      };
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      "hold-time" = mkOption {
                        description = "3s..1h    (time interval)";
                        default = null;
                        type = lib.types.str;
                      };
                      "input.accept-communities" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "input.accept-ext-communities" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "input.accept-large-communities" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "input.accept-nlri" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "input.accept-unknown" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "input.affinity" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "input.allow-as" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "input.filter" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "input.ignore-as-path-len" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "input.limit-process-routes-ipv4" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "input.limit-process-routes-ipv6" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "keepalive-time" = mkOption {
                        description = "1s..30m    (time interval)";
                        default = null;
                        type = lib.types.str;
                      };
                      multihop = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      name = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "nexthop-choice" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "output.affinity" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "output.default-originate" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "output.default-prepend" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "output.filter-chain" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "output.filter-select" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "output.keep-sent-attributes" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "output.network" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "output.no-client-to-client-reflection" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "output.no-early-cut" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "output.redistribute" = mkOption {
                        description = "connected|static|rip|ospf|bgp|vpn|dhcp|fantasy|modem|bgp-mpls-vpn[,OutputRedistribute*]";
                        default = null;
                        type = lib.types.str;
                      };
                      "remove-private-as" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "router-id" = mkOption {
                        description = "A.B.C.D    (IP address)";
                        default = null;
                        type = lib.types.str;
                      };
                      "routing-table" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "save-to" = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      templates = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "use-bfd" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      vrf = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "see documentation";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "template";
                      };
                    };
                  };
                };
                vpls = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      bridge = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "bridge-cost" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "bridge-horizon" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "cisco-id" = mkOption {
                        description = "see documentation";
                        default = null;
                        type = lib.types.str;
                      };
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      "export-route-targets" = mkOption {
                        description = "see documentation";
                        default = null;
                        type = lib.types.str;
                      };
                      "import-route-targets" = mkOption {
                        description = "see documentation";
                        default = null;
                        type = lib.types.str;
                      };
                      "local-pref" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      name = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "pw-control-word" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "pw-l2mtu" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "pw-type" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      rd = mkOption {
                        description = "see documentation";
                        default = null;
                        type = lib.types.str;
                      };
                      "site-id" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      vrf = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "vpls";
                      };
                    };
                  };
                };
                vpn = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      "export.filter-chain" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "export.filter-select" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "export.redistribute" = mkOption {
                        description = "connected|static|rip|ospf|bgp|vpn|dhcp|fantasy|modem[,ExportRedistribute*]";
                        default = null;
                        type = lib.types.str;
                      };
                      "export.route-targets" = mkOption {
                        description = "see documentation";
                        default = null;
                        type = lib.types.str;
                      };
                      "import.filter-chain" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "import.route-targets" = mkOption {
                        description = "see documentation";
                        default = null;
                        type = lib.types.str;
                      };
                      "import.router-id" = mkOption {
                        description = "A.B.C.D    (IP address)";
                        default = null;
                        type = lib.types.str;
                      };
                      "label-allocation-policy" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      name = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "route-distinguisher" = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      vrf = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "vpn";
                      };
                    };
                  };
                };
              };
            };
          };
          fantasy = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                count = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "dealer-id" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "dst-address" = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                gateway = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                "instance-id" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                offset = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "prefix-length" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "priv-offs" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "priv-size" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                scope = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                seed = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "target-scope" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "use-hold" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "fantasy";
                };
              };
            };
          };
          filter = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                chain = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                    };
                  };
                };
                "community-ext-list" = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      communities = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      "list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "place-before" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      regexp = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "\"community-ext-list\"";
                      };
                    };
                  };
                };
                "community-large-list" = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      communities = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      "list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "place-before" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      regexp = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "\"community-large-list\"";
                      };
                    };
                  };
                };
                "community-list" = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      communities = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      "list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "place-before" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      regexp = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "\"community-list\"";
                      };
                    };
                  };
                };
                "num-list" = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      "list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "place-before" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      range = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "\"num-list\"";
                      };
                    };
                  };
                };
                rule = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      chain = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      comment = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      "place-before" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      rule = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "rule";
                      };
                    };
                  };
                };
                "select-rule" = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      chain = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      "do-group-num" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "do-group-prfx" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "do-jump" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "do-select-num" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "do-select-prfx" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "do-take" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "do-where" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "place-before" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "\"select-rule\"";
                      };
                    };
                  };
                };
              };
            };
          };
          gmp = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                exclude = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                groups = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                interfaces = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                sources = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "gmp";
                };
              };
            };
          };
          id = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                id = mkOption {
                  description = "A.B.C.D    (IP address)";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "select-dynamic-id" = mkOption {
                  description = "any|only-static|only-loopback|only-vrf|only-active|lowest[,SelectDynamicId*]";
                  default = null;
                  type = lib.types.str;
                };
                "select-from-vrf" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "id";
                };
              };
            };
          };
          "igmp-proxy" = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                "query-interval" = mkOption {
                  description = "1s..1h    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "query-response-interval" = mkOption {
                  description = "1s..1h    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "quick-leave" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "\"igmp-proxy\"";
                };
              };
            };
          };
          nexthop = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
              };
            };
          };
          ospf = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                area = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      "area-id" = mkOption {
                        description = "A.B.C.D    (IP address)";
                        default = null;
                        type = lib.types.str;
                      };
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "default-cost" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      instance = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      name = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "no-summaries" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "nssa-translator" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      type = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "area";
                      };
                    };
                  };
                };
                instance = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      "domain-id" = mkOption {
                        description = "see documentation";
                        default = null;
                        type = lib.types.str;
                      };
                      "domain-tag" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-filter-chain" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "mpls-te-address" = mkOption {
                        description = "see documentation";
                        default = null;
                        type = lib.types.str;
                      };
                      "mpls-te-area" = mkOption {
                        description = "A.B.C.D    (IP address)";
                        default = null;
                        type = lib.types.str;
                      };
                      name = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "originate-default" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-filter-chain" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-filter-select" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      redistribute = mkOption {
                        description = "connected|static|rip|ospf|bgp|vpn|dhcp|fantasy|modem|bgp-mpls-vpn[,Redistribute*]";
                        default = null;
                        type = lib.types.str;
                      };
                      "router-id" = mkOption {
                        description = "A.B.C.D    (IP address)";
                        default = null;
                        type = lib.types.str;
                      };
                      "routing-table" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "use-dn" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      version = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      vrf = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "instance";
                      };
                    };
                  };
                };
                interface = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                    };
                  };
                };
                "interface-template" = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      area = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      auth = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "auth-id" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "auth-key" = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      cost = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "dead-interval" = mkOption {
                        description = "1s..18h12m15s    (time interval)";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      "hello-interval" = mkOption {
                        description = "1s..18h12m15s    (time interval)";
                        default = null;
                        type = lib.types.str;
                      };
                      "instance-id" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      interfaces = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      networks = mkOption {
                        description = "see documentation";
                        default = null;
                        type = lib.types.str;
                      };
                      passive = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "place-before" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "prefix-list" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      priority = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "retransmit-interval" = mkOption {
                        description = "1s..18h12m15s    (time interval)";
                        default = null;
                        type = lib.types.str;
                      };
                      "transmit-delay" = mkOption {
                        description = "1s..18h12m15s    (time interval)";
                        default = null;
                        type = lib.types.str;
                      };
                      type = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "vlink-neighbor-id" = mkOption {
                        description = "A.B.C.D    (IP address)";
                        default = null;
                        type = lib.types.str;
                      };
                      "vlink-transit-area" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "\"interface-template\"";
                      };
                    };
                  };
                };
                lsa = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                    };
                  };
                };
                neighbor = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "neighbor";
                      };
                    };
                  };
                };
                "static-neighbor" = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      address = mkOption {
                        description = "see documentation";
                        default = null;
                        type = lib.types.str;
                      };
                      area = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      "instance-id" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "poll-interval" = mkOption {
                        description = "time interval";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "\"static-neighbor\"";
                      };
                    };
                  };
                };
              };
            };
          };
          pimsm = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                bsr = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                      candidate = mkOption {
                        description = "";
                        default = {};
                        type = attrsOf submodule {
                          options = {
                            address = mkOption {
                              description = "see documentation";
                              default = null;
                              type = lib.types.str;
                            };
                            "copy-from" = mkOption {
                              description = "";
                              default = null;
                              type = lib.types.str;
                            };
                            enable = mkOption {
                              description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                              default = null;
                              type = lib.types.str;
                            };
                            "hashmask-length" = mkOption {
                              description = "";
                              default = null;
                              type = lib.types.str;
                            };
                            instance = mkOption {
                              description = "";
                              default = null;
                              type = lib.types.str;
                            };
                            priority = mkOption {
                              description = "";
                              default = null;
                              type = lib.types.str;
                            };
                            scope4 = mkOption {
                              description = "see documentation";
                              default = null;
                              type = lib.types.str;
                            };
                            scope6 = mkOption {
                              description = "";
                              default = null;
                              type = lib.types.str;
                            };
                            numbers = mkOption {
                              description = "";
                              default = null;
                              type = lib.types.str;
                            };
                            _create = mkOption {
                              description = "Creation script";
                              internal = true;
                              readOnly = true;
                              type = lib.types.str;
                              default = "# " + "candidate";
                            };
                          };
                        };
                      };
                      "rp-candidate" = mkOption {
                        description = "";
                        default = {};
                        type = attrsOf submodule {
                          options = {
                            address = mkOption {
                              description = "see documentation";
                              default = null;
                              type = lib.types.str;
                            };
                            "copy-from" = mkOption {
                              description = "";
                              default = null;
                              type = lib.types.str;
                            };
                            enable = mkOption {
                              description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                              default = null;
                              type = lib.types.str;
                            };
                            group = mkOption {
                              description = "see documentation";
                              default = null;
                              type = lib.types.str;
                            };
                            holdtime = mkOption {
                              description = "";
                              default = null;
                              type = lib.types.str;
                            };
                            instance = mkOption {
                              description = "";
                              default = null;
                              type = lib.types.str;
                            };
                            priority = mkOption {
                              description = "";
                              default = null;
                              type = lib.types.str;
                            };
                            numbers = mkOption {
                              description = "";
                              default = null;
                              type = lib.types.str;
                            };
                            _create = mkOption {
                              description = "Creation script";
                              internal = true;
                              readOnly = true;
                              type = lib.types.str;
                              default = "# " + "\"rp-candidate\"";
                            };
                          };
                        };
                      };
                      "rp-set" = mkOption {
                        description = "";
                        default = {};
                        type = submodule {
                          options = {
                          };
                        };
                      };
                    };
                  };
                };
                "igmp-interface-template" = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                      instance = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      interfaces = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "\"igmp-interface-template\"";
                      };
                    };
                  };
                };
                instance = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      afi = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "bsm-forward-back" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "crp-advertise-contained" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      name = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "rp-hash-mask-length" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "rp-static-override" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "ssm-range" = mkOption {
                        description = "see documentation";
                        default = null;
                        type = lib.types.str;
                      };
                      "switch-to-spt" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "switch-to-spt-bytes" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "switch-to-spt-interval" = mkOption {
                        description = "time interval";
                        default = null;
                        type = lib.types.str;
                      };
                      vrf = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "instance";
                      };
                    };
                  };
                };
                interface = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                    };
                  };
                };
                "interface-template" = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      "hello-delay" = mkOption {
                        description = "time interval";
                        default = null;
                        type = lib.types.str;
                      };
                      "hello-period" = mkOption {
                        description = "time interval";
                        default = null;
                        type = lib.types.str;
                      };
                      instance = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      interfaces = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "join-prune-period" = mkOption {
                        description = "time interval";
                        default = null;
                        type = lib.types.str;
                      };
                      "join-tracking-support" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "override-interval" = mkOption {
                        description = "time interval";
                        default = null;
                        type = lib.types.str;
                      };
                      "place-before" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      priority = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "propagation-delay" = mkOption {
                        description = "time interval";
                        default = null;
                        type = lib.types.str;
                      };
                      "source-addresses" = mkOption {
                        description = "see documentation";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "\"interface-template\"";
                      };
                    };
                  };
                };
                neighbor = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                    };
                  };
                };
                "static-rp" = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      address = mkOption {
                        description = "see documentation";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      group = mkOption {
                        description = "see documentation";
                        default = null;
                        type = lib.types.str;
                      };
                      instance = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "\"static-rp\"";
                      };
                    };
                  };
                };
                "uib-g" = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                    };
                  };
                };
                "uib-sg" = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                    };
                  };
                };
              };
            };
          };
          rip = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                instance = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      afi = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      "in-filter-chain" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      name = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "originate-default" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-filter-chain" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "out-filter-select" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      redistribute = mkOption {
                        description = "connected|static|rip|ospf|bgp|vpn|dhcp|fantasy|modem|bgp-mpls-vpn[,Redistribute*]";
                        default = null;
                        type = lib.types.str;
                      };
                      "route-gc-timeout" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "route-timeout" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "routing-table" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "update-interval" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      vrf = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "instance";
                      };
                    };
                  };
                };
                interface = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                    };
                  };
                };
                "interface-template" = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      cost = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      instance = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      interfaces = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "key-chain" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      mode = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      password = mkOption {
                        description = "string value, max length 16";
                        default = null;
                        type = lib.types.str;
                      };
                      "poison-reverse" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "source-addresses" = mkOption {
                        description = "see documentation";
                        default = null;
                        type = lib.types.str;
                      };
                      "split-horizon" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "\"interface-template\"";
                      };
                    };
                  };
                };
                keys = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      chain = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      key = mkOption {
                        description = "string value, max length 16";
                        default = null;
                        type = lib.types.str;
                      };
                      "key-id" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "valid-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "valid-till" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "keys";
                      };
                    };
                  };
                };
                neighbor = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                    };
                  };
                };
                "static-neighbor" = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      address = mkOption {
                        description = "see documentation";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      enable = mkOption {
                        description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                        default = null;
                        type = lib.types.str;
                      };
                      instance = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "\"static-neighbor\"";
                      };
                    };
                  };
                };
              };
            };
          };
          route = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "route";
                };
              };
            };
          };
          rpki = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                address = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "expire-interval" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                group = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                port = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                preference = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "refresh-interval" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "retry-interval" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                vrf = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "rpki";
                };
              };
            };
          };
          rule = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                action = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "dst-address" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                interface = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "min-prefix" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "place-before" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "routing-mark" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "src-address" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                table = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "rule";
                };
              };
            };
          };
          stats = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                memory = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                    };
                  };
                };
                origin = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                    };
                  };
                };
                pcap = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                    };
                  };
                };
                process = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                    };
                  };
                };
                step = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                    };
                  };
                };
              };
            };
          };
          table = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                fib = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "table";
                };
              };
            };
          };
        };
      };
    };
    snmp = mkOption {
      description = "";
      default = {};
      type = submodule {
        options = {
          contact = mkOption {
            description = "string value";
            default = null;
            type = lib.types.str;
          };
          enabled = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          "engine-id" = mkOption {
            description = "string value";
            default = null;
            type = lib.types.str;
          };
          location = mkOption {
            description = "string value";
            default = null;
            type = lib.types.str;
          };
          "src-address" = mkOption {
            description = "A.B.C.D    (IP address)";
            default = null;
            type = lib.types.str;
          };
          "trap-community" = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          "trap-generators" = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          "trap-interfaces" = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          "trap-target" = mkOption {
            description = "see documentation";
            default = null;
            type = lib.types.str;
          };
          "trap-version" = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          vrf = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          _create = mkOption {
            description = "Creation script";
            internal = true;
            readOnly = true;
            type = lib.types.str;
            default = "# " + "snmp";
          };
        };
      };
    };
    "special-login" = mkOption {
      description = "";
      default = {};
      type = attrsOf submodule {
        options = {
          channel = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          "copy-from" = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          enable = mkOption {
            description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
            default = null;
            type = lib.types.str;
          };
          port = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          user = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          numbers = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          _create = mkOption {
            description = "Creation script";
            internal = true;
            readOnly = true;
            type = lib.types.str;
            default = "# " + "\"special-login\"";
          };
        };
      };
    };
    system = mkOption {
      description = "";
      default = {};
      type = submodule {
        options = {
          backup = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                cloud = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                    };
                  };
                };
              };
            };
          };
          clock = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                date = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                time = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "time-zone-autodetect" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "time-zone-name" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "clock";
                };
              };
            };
          };
          console = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                channel = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                port = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                term = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "console";
                };
              };
            };
          };
          "default-configuration" = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                "caps-mode-script" = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                    };
                  };
                };
                "custom-script" = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                    };
                  };
                };
                script = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                    };
                  };
                };
              };
            };
          };
          "device-mode" = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
              };
            };
          };
          hardware = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                "multi-cpu" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "hardware";
                };
              };
            };
          };
          health = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                "state-after-reboot" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "health";
                };
              };
            };
          };
          history = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
              };
            };
          };
          identity = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "identity";
                };
              };
            };
          };
          leds = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                interface = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                leds = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "modem-signal-threshold" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                type = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "leds";
                };
              };
            };
          };
          license = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
              };
            };
          };
          logging = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                action = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                prefix = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                topics = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "logging";
                };
              };
            };
          };
          note = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                note = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "show-at-login" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "note";
                };
              };
            };
          };
          ntp = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                client = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                      enabled = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      mode = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      servers = mkOption {
                        description = "see documentation";
                        default = null;
                        type = lib.types.str;
                      };
                      vrf = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "client";
                      };
                    };
                  };
                };
                key = mkOption {
                  description = "";
                  default = {};
                  type = attrsOf submodule {
                    options = {
                      comment = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "copy-from" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "key-id" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "key-val" = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "key";
                      };
                    };
                  };
                };
                server = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                      "auth-key" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      broadcast = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "broadcast-addresses" = mkOption {
                        description = "A.B.C.D    (IP address)";
                        default = null;
                        type = lib.types.str;
                      };
                      enabled = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "local-clock-stratum" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      manycast = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      multicast = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "use-local-clock" = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      vrf = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "server";
                      };
                    };
                  };
                };
              };
            };
          };
          package = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                update = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                      channel = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "update";
                      };
                    };
                  };
                };
              };
            };
          };
          resource = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                cpu = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                    };
                  };
                };
                irq = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                      cpu = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "irq";
                      };
                    };
                  };
                };
                pci = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                    };
                  };
                };
                usb = mkOption {
                  description = "";
                  default = {};
                  type = submodule {
                    options = {
                      device = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "device-id" = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      name = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      numbers = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      ports = mkOption {
                        description = "";
                        default = null;
                        type = lib.types.str;
                      };
                      "serial-number" = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      speed = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "usb-version" = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      vendor = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      "vendor-id" = mkOption {
                        description = "string value";
                        default = null;
                        type = lib.types.str;
                      };
                      _create = mkOption {
                        description = "Creation script";
                        internal = true;
                        readOnly = true;
                        type = lib.types.str;
                        default = "# " + "usb";
                      };
                    };
                  };
                };
              };
            };
          };
          scheduler = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                interval = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "on-event" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                policy = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "start-date" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "start-time" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "scheduler";
                };
              };
            };
          };
          script = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "dont-require-permissions" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                owner = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                policy = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                source = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "script";
                };
              };
            };
          };
          upgrade = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                download = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "upgrade";
                };
              };
            };
          };
          ups = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                "alarm-setting" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "check-capabilities" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "min-runtime" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "offline-time" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                port = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "ups";
                };
              };
            };
          };
          watchdog = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                "auto-send-supout" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "automatic-supout" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "ping-start-after-boot" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "ping-timeout" = mkOption {
                  description = "10s..10m    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "send-email-from" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "send-email-to" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "send-smtp-server" = mkOption {
                  description = "A.B.C.D    (IP address)";
                  default = null;
                  type = lib.types.str;
                };
                "watch-address" = mkOption {
                  description = "none | A.B.C.D    (IP address)";
                  default = null;
                  type = lib.types.str;
                };
                "watchdog-timer" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "watchdog";
                };
              };
            };
          };
        };
      };
    };
    task = mkOption {
      description = "";
      default = {};
      type = attrsOf submodule {
        options = {
          append = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          "copy-from" = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          "file-name" = mkOption {
            description = "string value";
            default = null;
            type = lib.types.str;
          };
          "max-lines" = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          "max-size" = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          "no-header-paging" = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          "save-interval" = mkOption {
            description = "10s..1h    (time interval)";
            default = null;
            type = lib.types.str;
          };
          "save-timestamp" = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          source = mkOption {
            description = "string value";
            default = null;
            type = lib.types.str;
          };
          "switch-to" = mkOption {
            description = "";
            default = null;
            type = lib.types.str;
          };
          _create = mkOption {
            description = "Creation script";
            internal = true;
            readOnly = true;
            type = lib.types.str;
            default = "# " + "task";
          };
        };
      };
    };
    terminal = mkOption {
      description = "";
      default = {};
      type = submodule {
        options = {
        };
      };
    };
    tool = mkOption {
      description = "";
      default = {};
      type = submodule {
        options = {
          "bandwidth-server" = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                "allocate-udp-ports-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                authenticate = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enabled = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "max-sessions" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "\"bandwidth-server\"";
                };
              };
            };
          };
          "e-mail" = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                address = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                from = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                password = mkOption {
                  description = "string value, max length 255";
                  default = null;
                  type = lib.types.str;
                };
                port = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                tls = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                user = mkOption {
                  description = "string value, max length 255";
                  default = null;
                  type = lib.types.str;
                };
                vrf = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "\"e-mail\"";
                };
              };
            };
          };
          graphing = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                "page-refresh" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "store-every" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "graphing";
                };
              };
            };
          };
          "mac-server" = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                "allowed-interface-list" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "\"mac-server\"";
                };
              };
            };
          };
          netwatch = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                certificate = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "check-certificate" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                "down-script" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                host = mkOption {
                  description = "see documentation";
                  default = null;
                  type = lib.types.str;
                };
                "http-codes" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                interval = mkOption {
                  description = "1s..71w2h27m52s950ms    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "packet-count" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "packet-interval" = mkOption {
                  description = "20ms..71w2h27m52s950ms    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "packet-size" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                port = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "start-delay" = mkOption {
                  description = "0s..1h    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "startup-delay" = mkOption {
                  description = "0s..1h    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                "test-script" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "thr-avg" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "thr-http-time" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "thr-jitter" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "thr-loss-count" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "thr-loss-percent" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "thr-max" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "thr-stdev" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "thr-tcp-conn-time" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                timeout = mkOption {
                  description = "10ms..4w    (time interval)";
                  default = null;
                  type = lib.types.str;
                };
                type = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "up-script" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "netwatch";
                };
              };
            };
          };
          romon = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                enabled = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                id = mkOption {
                  description = "AB[:|-|.]CD[:|-|.]EF[:|-|.]GH[:|-|.]IJ[:|-|.]KL    (MAC address)";
                  default = null;
                  type = lib.types.str;
                };
                secrets = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "romon";
                };
              };
            };
          };
          sms = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                "allowed-number" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "auto-erase" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                channel = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                port = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "receive-enabled" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                secret = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "sim-pin" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "sms";
                };
              };
            };
          };
          sniffer = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                "file-limit" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "file-name" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "filter-cpu" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "filter-direction" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "filter-dst-ip-address" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "filter-dst-ipv6-address" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "filter-dst-mac-address" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "filter-dst-port" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "filter-interface" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "filter-ip-address" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "filter-ip-protocol" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "filter-ipv6-address" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "filter-mac-address" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "filter-mac-protocol" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "filter-operator-between-entries" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "filter-port" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "filter-size" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "filter-src-ip-address" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "filter-src-ipv6-address" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "filter-src-mac-address" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "filter-src-port" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "filter-stream" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "filter-vlan" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "memory-limit" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "memory-scroll" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "only-headers" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "streaming-enabled" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "streaming-server" = mkOption {
                  description = "A.B.C.D    (IP address)";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "sniffer";
                };
              };
            };
          };
          "traffic-generator" = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                "latency-distribution-max" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "measure-out-of-order" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "stats-samples-to-keep" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "test-id" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "\"traffic-generator\"";
                };
              };
            };
          };
          "traffic-monitor" = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                enable = mkOption {
                  description = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config";
                  default = null;
                  type = lib.types.str;
                };
                interface = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "on-event" = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                threshold = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                traffic = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                trigger = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "\"traffic-monitor\"";
                };
              };
            };
          };
        };
      };
    };
    user = mkOption {
      description = "";
      default = {};
      type = submodule {
        options = {
          aaa = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                accounting = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "default-group" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "exclude-groups" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "interim-update" = mkOption {
                  description = "time interval";
                  default = null;
                  type = lib.types.str;
                };
                "use-radius" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "aaa";
                };
              };
            };
          };
          active = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
              };
            };
          };
          group = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                name = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                policy = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                skin = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                numbers = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "group";
                };
              };
            };
          };
          settings = mkOption {
            description = "";
            default = {};
            type = submodule {
              options = {
                "minimum-categories" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                "minimum-password-length" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "settings";
                };
              };
            };
          };
          "ssh-keys" = mkOption {
            description = "";
            default = {};
            type = attrsOf submodule {
              options = {
                comment = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                "copy-from" = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                key = mkOption {
                  description = "string value";
                  default = null;
                  type = lib.types.str;
                };
                user = mkOption {
                  description = "";
                  default = null;
                  type = lib.types.str;
                };
                _create = mkOption {
                  description = "Creation script";
                  internal = true;
                  readOnly = true;
                  type = lib.types.str;
                  default = "# " + "\"ssh-keys\"";
                };
              };
            };
          };
        };
      };
    };
  };
}
