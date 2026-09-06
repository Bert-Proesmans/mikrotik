{ lib, config, ... }: {
  configVersion = "7.23.1";

  interface = {
    list = {
      "WAN" = { };
      "LAN" = { };
    };

    list.member = [
      {
        list = "WAN";
        member = "ether1";
      }
    ];

    ethernet = {
      # Do not force uninitialized properties on the target
      default-stub = true;
      "ether1" = {
        # stub = false;
      };
      "ether2" = { };
      "ether3" = {
        bridge-port = config.ethernet.bridge.bridge1.name; # virtual property
      };
      "ether4" = { };
      "ether5" = { };
      # /interface bridge port add bridge=bridge comment=defconf ingress-filtering=no interface=ether2 internal-path-cost=10 path-cost=10
      # /interface bridge port add bridge=bridge comment=defconf ingress-filtering=no interface=ether3 internal-path-cost=10 path-cost=10
      # /interface bridge port add bridge=bridge comment=defconf ingress-filtering=no interface=ether4 internal-path-cost=10 path-cost=10
      # /interface bridge port add bridge=bridge comment=defconf ingress-filtering=no interface=ether5 internal-path-cost=10 path-cost=10
    };

    bridge."bridge1" = {
      enable = true;
      auto-mac = true;
      protocol-mode = "rstp";
      # https://www.hellion.org.uk/cgi-bin/randmac.pl
      admin-mac = "76:32:af:2b:7d:5b";
      #
      list-member = config.interface.list.LAN.name; # virtual property
    };

    bridge.port = [
      {
        bridge = "bridge1";
        port = "ether2";
      }
    ];

    pppoe-client."ppoe1" = {
      enable = true;
      interface = config.interface.ethernet.ether1.name;
      add-default-route = true;
      default-route-distance = 11;
      user = lib.mkDefault null; # Omitted
    };
  };

  ip = {
    pool."default".ranges = "192.168.88.10-192.168.88.254";
    dhcp-server."default" = {
      interface = config.interface.bridge.bridge1.name;
      lease-time = lib.mkHours 3;
      address-pool = config.ip.pool.default.name;
    };

    address."192.168.88.1/24".interface = config.interface.bridge.bridge1.name;
    dhcp-client."scarlet-ipv4".interface = config.interface.ethernet.ether1.name;

    # /ip dhcp-server lease add address=192.168.88.11 comment="Hypervisor ALPHA - reservation" mac-address=B4:2E:99:15:33:A6 server=defconf
    # /ip dhcp-server lease add address=192.168.88.8 comment="FILE-SERVER reservation" mac-address=36:25:F7:81:5F:D0 server=defconf
    # /ip dhcp-server lease add address=192.168.88.10 comment="Hypervisor ALPHA - reservation" disabled=yes mac-address=4A:5C:7C:D1:8A:35 server=defconf
    # /ip dhcp-server lease add address=192.168.88.47 mac-address=26:FA:77:05:26:BC server=defconf
    # /ip dhcp-server lease add address=192.168.88.17 mac-address=9E:30:E8:E8:B1:D0 server=defconf
    # /ip dhcp-server lease add address=192.168.88.56 mac-address=42:DE:E5:CE:A8:D6 server=defconf
    # /ip dhcp-server lease add address=192.168.88.30 mac-address=52:0D:DA:28:B9:5B server=defconf
    # /ip dhcp-server lease add address=192.168.88.245 mac-address=D8:BB:C1:04:AA:8A server=defconf
    # /ip dhcp-server lease add address=192.168.88.23 comment="Hypervisor BETA" mac-address=1C:1B:0D:A0:B7:9B server=defconf
    # /ip dhcp-server network add address=192.168.88.0/24 comment=defconf dns-server=192.168.88.1 gateway=192.168.88.1

    dns = {
      allow-remote-requests = true; # yes/no
      # Requires bigger size to hold negative entries from blocklist!
      cache-size = lib.mkKilo 9216;
      use-doh-server = "https://security.cloudflare-dns.com/dns-query";
      verify-doh-cert = true; # yes/no

      adlist = [
        {
          url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews/hosts";
        }
      ];

      static = [
        {
          comment = "bootstrap DNS";
          name = "security.cloudflare-dns.com";
          type = "A";
          address = "1.1.1.2";
        }
        {
          comment = "bootstrap DNS";
          name = "security.cloudflare-dns.com";
          type = "AAAA";
          address = "2606:4700:4700::1112";
        }
        {
          name = "router.local";
          type = "A";
          address = "192.168.88.1";

        }
        {
          # WARN; Use mDNS instead! => buddy.local
          name = "buddy.internal.proesmans.eu";
          type = "A";
          address = "192.168.88.11";
        }
      ];
    };

    # /ip dns static add address=fe80::139 name=development.internal.proesmans.eu type=AAAA
    # /ip dns static add address=192.168.88.11 disabled=yes name=idm.proesmans.eu type=A
    # /ip dns static add address=192.168.88.11 disabled=yes name=alpha.idm.proesmans.eu type=A
    # /ip dns static add address=192.168.88.11 disabled=yes name=pictures.proesmans.eu type=A
    # /ip dns static add address=192.168.88.11 name=alpha.pictures.proesmans.eu type=A
    # /ip dns static add address=192.168.88.11 disabled=yes name=passwords.proesmans.eu type=A
    # /ip dns static add address=192.168.88.11 disabled=yes name=wiki.proesmans.eu type=A
    # /ip dns static add address=192.168.88.11 disabled=yes name=alpha.passwords.proesmans.eu type=A
    # /ip dns static add address=192.168.88.11 disabled=yes name=alpha.wiki.proesmans.eu type=A
  };

  queue = {
    type = {
      "default".stub = true;

      "red-download" = {
        kind = "red";
        red-avg-packet = 1500;
        red-burst = 10;
        red-limit = 40;
        red-max-threshold = 40;
      };
      "red-upload" = {
        kind = "red";
        red-avg-packet = 1500;
        red-burst = 5;
        red-limit = 20;
        red-max-threshold = 20;
        red-min-threshold = 5;
      };
      "default-sfq" = {
        kind = "sfq";
      };

      "pcq-upload-default" = {
        stub = true;
        # Type; bits/s
        pcq-rate = lib.mkMega 5;
        # Type; bits (unit)
        pcq-total-limit = lib.mkKilo 25000;
      };

      "pcq-download-default" = {
        stub = true;
        # Type; bits/s
        pcq-rate = lib.mkMega 40;
        # Type; bits (unit)
        pcq-total-limit = lib.mkKilo 25000;
      };
    };

    tree."INTERNET_UP" = {
      parent = config.interface.pppoe-client.ppoe1.name;
      queue = "default";
      max-limit = lib.mkMega 15;
      # virtual property
      children = [
        {
          name = "ACK_U";
          # priority = 1; # Implicit

        }
        # /queue tree add limit-at=1500k max-limit=15M name=ACK_U packet-mark=ACK parent="customconf: TOTAL_UP" priority=1 queue=default
        # /queue tree add limit-at=1500k max-limit=15M name=VOIP_U packet-mark=VOIP parent="customconf: TOTAL_UP" priority=2 queue=default
        # /queue tree add limit-at=1500k max-limit=15M name=GAMES_U packet-mark=GAMES parent="customconf: TOTAL_UP" priority=3 queue=default-sfq
        # /queue tree add limit-at=1500k max-limit=15M name=DNS_U packet-mark=DNS parent="customconf: TOTAL_UP" priority=4 queue=default
        # /queue tree add limit-at=1500k max-limit=15M name=ICMP_U packet-mark=ICMP parent="customconf: TOTAL_UP" priority=5 queue=default
        # /queue tree add limit-at=100k max-limit=5M name=HTTP_U packet-mark=HTTP parent="customconf: TOTAL_UP" priority=6 queue=pcq-upload-default
        # /queue tree add limit-at=100k max-limit=5M name=HTTP_U_BIG packet-mark=HTTP_BIG parent="customconf: TOTAL_UP" priority=7 queue=pcq-upload-default
        # /queue tree add limit-at=100k max-limit=5M name=OTHER_U packet-mark=OTHER parent="customconf: TOTAL_UP" queue=red-upload
        # /queue tree add limit-at=100k max-limit=5M name=OTHER_U_BIG packet-mark=OTHER_BIG parent="customconf: TOTAL_UP" queue=red-upload
      ];
    };

    tree."INTERNET_DOWN" = {
      parent = config.interface.bridge.bridge1.name;
      queue = "default";
      max-limit = lib.mkMega 45;
      # virtual property
      children = [
        {
          name = "ACK_D";
          # priority = 1; # Implicit
        }
        # /queue tree add limit-at=4M max-limit=45M name=ACK_D packet-mark=ACK parent="customconf: TOTAL_DOWN" priority=1 queue=default
        # /queue tree add limit-at=4M max-limit=45M name=VOIP_D packet-mark=VOIP parent="customconf: TOTAL_DOWN" priority=2 queue=default
        # /queue tree add limit-at=4M max-limit=45M name=GAMES_D packet-mark=GAMES parent="customconf: TOTAL_DOWN" priority=3 queue=default
        # /queue tree add limit-at=4M max-limit=45M name=DNS_D packet-mark=DNS parent="customconf: TOTAL_DOWN" priority=4 queue=default
        # /queue tree add limit-at=4M max-limit=45M name=ICMP_D packet-mark=ICMP parent="customconf: TOTAL_DOWN" priority=5 queue=default
        # /queue tree add limit-at=250k max-limit=45M name=HTTP_D packet-mark=HTTP parent="customconf: TOTAL_DOWN" priority=6 queue=pcq-download-default
        # /queue tree add limit-at=250k max-limit=40M name=HTTP_D_BIG packet-mark=HTTP_BIG parent="customconf: TOTAL_DOWN" priority=7 queue=pcq-download-default
        # /queue tree add limit-at=250k max-limit=45M name=OTHER_D packet-mark=OTHER parent="customconf: TOTAL_DOWN" queue=red-download
        # /queue tree add limit-at=250k max-limit=40M name=OTHER_D_BIG packet-mark=OTHER_BIG parent="customconf: TOTAL_DOWN" queue=red-download
      ];
    };
  };

  user = {
    "admin" = {
      enable = false;
      stub = true;
    };
    "bertp" = {
      enable = true;
      group = "full";
    };
  };

  system = {
    identity.name = "ALPHA Proesmans";
    # note.note = "ALPHA Proesmans EDGE router";
    package.update.channel = "long-term";
    clock.time-zone-name = "Europe/Brussels";

    script."wake_buddy" = {
      comment = "Wake Alpha buddy";
      dont-require-permissions = false;
      owner = config.user.bertp.name;
      policy = [ "test" ];
      source = ''
        /tool wol interface=bridge mac=B4:2E:99:15:33:A6
        /tool wol interface=bridge mac=B4:2E:99:15:33:A6
        /tool wol interface=bridge mac=B4:2E:99:15:33:A6
      '';
    };
    scheduler."daily_buddy_wake" = {
      start-date = "2026-06-08";
      start-time = "18:30:00";
      interval = lib.mkDays 1;
      policy = [ "test" ];
      on-event = config.system.script.wake_buddy.name;
    };

    # /system logging set 0 topics=info,!dhcp
  };

  ip.firewall.connection-tracking.udp-timeout = lib.mkSeconds 10;
  ip.neighbor.discovery-settings.discover-interface-list = config.interface.list.LAN.name;
  ip.settings.rp-filter = "strict";
  ipv6.settings = {
    accept-redirects = false; # yes/no
    accept-router-advertisements = false; # yes/no
    accept-router-advertisements-on = "none";
    allow-fast-path = false;
    max-neighbor-entries = 8192;
  };

  # /ipv6 nd set [ find default=yes ] advertise-dns=yes disabled=yes
  # /ipv6 nd add interface="PPOE 1"
  # /ipv6 nd add advertise-dns=self interface=bridge managed-address-configuration=yes ra-preference=high
  # /ipv6 nd proxy add address=2a02:a03f:971f:1f00:: comment="workaround; missing DUID scarlet" interface="PPOE 1"

  # /ip firewall service-port set ftp disabled=yes
  # /ip firewall service-port set tftp disabled=yes
  # /ip firewall service-port set h323 disabled=yes
  # /ip firewall service-port set sip disabled=yes
  # /ip firewall service-port set pptp disabled=yes
  # /ip firewall service-port set udplite disabled=yes
  # /ip firewall service-port set dccp disabled=yes
  # /ip firewall service-port set sctp disabled=yes

  ip.service = {
    api-ssl.enable = false;
    api.enable = false;
    ftp.enable = false;
    # WARN; Set default to 127.0.0.1
    ssh.address = "192.168.88.0/24";
    # WARN; Set default to disable
    telnet.enable = false;
    winbox.address = "192.168.88.0/24";
    www.enable = false;
  };

  # WARN; Set default to empty list
  # Make bfd configuration explicitly empty to remove default enabled config!
  routing.bfd.configuration = [ ];

  tool.mac-server = {
    # WARN; Set default to empty list
    allowed-interface-list = config.interface.list.LAN.name;
    # WARN; Set default to empty list
    mac-winbox.allowed-interface-list = config.interface.list.LAN.name;
  };
  tool.sniffer = {
    filter-stream = true; # yes/no
    streaming-enabled = true; # yes/no
    streaming-server = "192.168.88.245";
    # filter-interface="PPOE 1";
    # filter-ipv6-address=::/0;
  };
  # WARN; Set default to false
  tool.bandwidth-server.enable = false;

  # /ip firewall address-list add address=8.23.24.0/23 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=43.229.64.0/22 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=43.229.64.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=43.229.65.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=43.229.66.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=43.229.67.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=45.7.36.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=45.7.39.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=45.250.208.0/22 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=66.151.33.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=103.219.128.0/22 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=103.240.224.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=103.240.225.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=103.240.226.0/23 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=104.160.128.0/19 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=104.160.128.0/20 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=104.160.134.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=104.160.135.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=104.160.136.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=104.160.139.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=104.160.141.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=104.160.142.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=104.160.143.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=104.160.144.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=104.160.145.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=104.160.146.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=104.160.147.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=104.160.148.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=104.160.149.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=104.160.152.0/21 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=104.160.153.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=104.160.154.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=104.160.155.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=104.160.156.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=110.45.191.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=117.52.75.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=117.52.76.0/22 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=117.52.101.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=138.0.12.0/22 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=138.0.12.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=138.0.13.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=138.0.14.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=138.0.15.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=162.249.72.0/22 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=162.249.76.0/22 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=162.249.79.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=182.162.120.0/21 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=185.40.64.0/22 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=192.64.168.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=192.64.169.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=192.64.170.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=192.64.171.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=192.64.172.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=192.64.173.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=192.64.174.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=192.64.175.0/24 comment="customconf: League of Legends West" list=games
  # /ip firewall address-list add address=146.66.152.0/23 comment="customconf: Steam Europe" list=games
  # /ip firewall address-list add address=146.66.154.0/24 comment="customconf: Steam Europe" list=games
  # /ip firewall address-list add address=146.66.155.0/24 comment="customconf: Steam Europe" list=games
  # /ip firewall address-list add address=146.66.156.0/23 comment="customconf: Steam Europe" list=games
  # /ip firewall address-list add address=146.66.158.0/23 comment="customconf: Steam Europe" list=games
  # /ip firewall address-list add address=185.25.180.0/23 comment="customconf: Steam Europe" list=games
  # /ip firewall address-list add address=185.25.182.0/24 comment="customconf: Steam Europe" list=games
  # /ip firewall address-list add address=185.25.183.0/24 comment="customconf: Steam Europe" list=games
  # /ip firewall address-list add address=155.133.224.0/23 comment="customconf: Steam Europe" list=games
  # /ip firewall address-list add address=155.133.227.0/24 comment="customconf: Steam Europe" list=games
  # /ip firewall address-list add address=155.133.228.0/23 comment="customconf: Steam Europe" list=games
  # /ip firewall address-list add address=155.133.230.0/23 comment="customconf: Steam Europe" list=games
  # /ip firewall address-list add address=155.133.232.0/24 comment="customconf: Steam Europe" list=games
  # /ip firewall address-list add address=155.133.233.0/24 comment="customconf: Steam Europe" list=games
  # /ip firewall address-list add address=155.133.234.0/24 comment="customconf: Steam Europe" list=games
  # /ip firewall address-list add address=155.133.235.0/24 comment="customconf: Steam Europe" list=games
  # /ip firewall address-list add address=155.133.236.0/23 comment="customconf: Steam Europe" list=games
  # /ip firewall address-list add address=155.133.238.0/24 comment="customconf: Steam Europe" list=games
  # /ip firewall address-list add address=155.133.239.0/24 comment="customconf: Steam Europe" list=games
  # /ip firewall address-list add address=155.133.240.0/23 comment="customconf: Steam Europe" list=games
  # /ip firewall address-list add address=155.133.242.0/23 comment="customconf: Steam Europe" list=games
  # /ip firewall address-list add address=155.133.244.0/24 comment="customconf: Steam Europe" list=games
  # /ip firewall address-list add address=155.133.245.0/24 comment="customconf: Steam Europe" list=games
  # /ip firewall address-list add address=155.133.246.0/23 comment="customconf: Steam Europe" list=games
  # /ip firewall address-list add address=155.133.248.0/24 comment="customconf: Steam Europe" list=games
  # /ip firewall address-list add address=155.133.249.0/24 comment="customconf: Steam Europe" list=games
  # /ip firewall address-list add address=155.133.250.0/24 comment="customconf: Steam Europe" list=games
  # /ip firewall address-list add address=155.133.252.0/24 comment="customconf: Steam Europe" list=games
  # /ip firewall address-list add address=155.133.253.0/24 comment="customconf: Steam Europe" list=games
  # /ip firewall address-list add address=155.133.254.0/24 comment="customconf: Steam Europe" list=games
  # /ip firewall address-list add address=155.133.255.0/24 comment="customconf: Steam Europe" list=games
  # /ip firewall address-list add address=5.42.160.0/20 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=5.42.176.0/20 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=37.244.15.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=37.244.16.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=37.244.17.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=37.244.18.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=37.244.19.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=37.244.20.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=37.244.21.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=37.244.22.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=37.244.23.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=37.244.24.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=37.244.25.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=37.244.26.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=37.244.27.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=37.244.28.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=37.244.29.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=37.244.30.0/23 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=37.244.32.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=37.244.33.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=37.244.34.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=37.244.35.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=37.244.36.0/23 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=37.244.38.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=37.244.40.0/22 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=37.244.44.0/22 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=37.244.48.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=37.244.49.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=37.244.50.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=37.244.52.0/23 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=37.244.54.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=37.244.55.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=37.244.56.0/23 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=37.244.58.0/23 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=37.244.60.0/22 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=185.60.112.0/23 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=185.60.114.0/23 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=137.221.64.0/19 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=137.221.64.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=137.221.68.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=137.221.69.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=137.221.70.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=137.221.71.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=137.221.72.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=137.221.73.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=137.221.74.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=137.221.75.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=137.221.76.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=137.221.77.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=137.221.78.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=137.221.79.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=137.221.80.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=137.221.81.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=137.221.82.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=137.221.83.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=137.221.84.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=137.221.85.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=137.221.86.0/24 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=137.221.96.0/22 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=137.221.100.0/22 comment="customconf: Blizzard Europe" list=games
  # /ip firewall address-list add address=137.221.104.0/22 comment="customconf: Blizzard Europe" list=games

  # /ip firewall filter add action=accept chain=input comment="defconf: accept established,related,untracked" connection-state=established,related,untracked
  # /ip firewall filter add action=drop chain=input comment="defconf: drop invalid" connection-state=invalid
  # /ip firewall filter add action=accept chain=input comment="defconf: accept ICMP" protocol=icmp
  # /ip firewall filter add action=accept chain=input disabled=yes
  # /ip firewall filter add action=drop chain=input comment="defconf: drop all not coming from LAN" in-interface-list=!LAN
  # /ip firewall filter add action=fasttrack-connection chain=forward comment="defconf: fasttrack" connection-state=established,related disabled=yes
  # /ip firewall filter add action=accept chain=forward comment="defconf: accept established,related" connection-state=established,related
  # /ip firewall filter add action=drop chain=forward comment="defconf: drop invalid" connection-state=invalid
  # /ip firewall filter add action=accept chain=forward comment="defconf: accept in ipsec policy" ipsec-policy=in,ipsec
  # /ip firewall filter add action=accept chain=forward comment="defconf: accept out ipsec policy" ipsec-policy=out,ipsec
  # /ip firewall filter add action=drop chain=forward comment="defconf: drop all from WAN not DSTNATed" connection-nat-state=!dstnat connection-state=new in-interface-list=WAN
  # /ip firewall filter add action=drop chain=forward comment="DROP all" connection-state="" in-interface-list=!LAN

  # /ip firewall mangle add action=log chain=notes comment="customconf: Start of QoS tree."
  # /ip firewall mangle add action=mark-connection chain=postrouting comment="customconf: OTHER - mark external traffic dstnat'ed to buddy server" connection-mark=no-mark dst-address=192.168.88.11 new-connection-mark=OTHER passth
  # rough=no protocol=tcp src-address=!192.168.88.0/24
  # /ip firewall mangle add action=mark-connection chain=postrouting comment="customconf: GAMES" connection-mark=no-mark dst-address-list=games new-connection-mark=GAMES passthrough=no
  # /ip firewall mangle add action=mark-connection chain=postrouting comment="customconf: DNS" connection-mark=no-mark new-connection-mark=DNS passthrough=no port=53 protocol=udp
  # /ip firewall mangle add action=mark-connection chain=postrouting comment="customconf: ICMP" connection-mark=no-mark new-connection-mark=ICMP passthrough=no protocol=icmp
  # /ip firewall mangle add action=mark-connection chain=input comment="customconf: WINBOX" connection-mark=no-mark new-connection-mark=ICMP passthrough=no port=8291 protocol=tcp
  # /ip firewall mangle add action=mark-connection chain=postrouting comment="customconf: HTTP" connection-mark=no-mark new-connection-mark=HTTP passthrough=no port=80,81,443,444,554,8000,8080,8409 protocol=tcp
  # /ip firewall mangle add action=mark-connection chain=postrouting comment="customconf: QUIC" connection-mark=no-mark new-connection-mark=HTTP passthrough=no port=80,81,443,444,554,8000,8080,8409 protocol=udp
  # /ip firewall mangle add action=mark-connection chain=postrouting comment="customconf: VOIP" connection-mark=no-mark connection-rate=0-100k new-connection-mark=VOIP packet-size=0-260 passthrough=no port=55000-65000 protocol=ud
  # p
  # /ip firewall mangle add action=mark-connection chain=postrouting comment="customconf: OTHER" connection-mark=no-mark new-connection-mark=OTHER passthrough=no protocol=tcp
  # /ip firewall mangle add action=mark-connection chain=postrouting comment="customconf: OTHER" connection-mark=no-mark new-connection-mark=OTHER passthrough=no protocol=udp
  # /ip firewall mangle add action=mark-connection chain=postrouting comment="customconf: HTTP BIG" connection-bytes=2000000-0 connection-mark=HTTP new-connection-mark=HTTP_BIG passthrough=no protocol=tcp
  # /ip firewall mangle add action=mark-connection chain=postrouting comment="customconf: QUIC BIG" connection-bytes=2000000-0 connection-mark=HTTP new-connection-mark=HTTP_BIG passthrough=no protocol=udp
  # /ip firewall mangle add action=mark-connection chain=postrouting comment="customconf: OTHER BIG" connection-bytes=500000-0 connection-mark=OTHER new-connection-mark=OTHER_BIG passthrough=no protocol=tcp
  # /ip firewall mangle add action=mark-connection chain=postrouting comment="customconf: OTHER BIG" connection-bytes=500000-0 connection-mark=OTHER new-connection-mark=OTHER_BIG passthrough=no protocol=udp
  # /ip firewall mangle add action=mark-connection chain=postrouting comment="customconf: OTHER BIG" connection-bytes=500000 connection-mark=VOIP connection-rate=200k-100M new-connection-mark=OTHER_BIG passthrough=no protocol=udp
  # /ip firewall mangle add action=set-priority chain=postrouting comment=customconf: connection-mark=VOIP new-priority=6
  # /ip firewall mangle add action=change-dscp chain=postrouting comment=customconf: connection-mark=VOIP new-dscp=48
  # /ip firewall mangle add action=set-priority chain=postrouting comment=customconf: connection-mark=DNS new-priority=6
  # /ip firewall mangle add action=change-dscp chain=postrouting comment=customconf: connection-mark=DNS new-dscp=48
  # /ip firewall mangle add action=set-priority chain=postrouting comment=customconf: connection-mark=ICMP new-priority=6
  # /ip firewall mangle add action=change-dscp chain=postrouting comment=customconf: connection-mark=ICMP new-dscp=48
  # /ip firewall mangle add action=mark-packet chain=postrouting comment=customconf: new-packet-mark=ACK packet-size=0-123 passthrough=no protocol=tcp tcp-flags=ack
  # /ip firewall mangle add action=mark-packet chain=postrouting comment=customconf: connection-mark=DNS new-packet-mark=DNS passthrough=no
  # /ip firewall mangle add action=mark-packet chain=postrouting comment=customconf: connection-mark=ICMP new-packet-mark=ICMP passthrough=no
  # /ip firewall mangle add action=mark-packet chain=postrouting comment=customconf: connection-mark=VOIP new-packet-mark=VOIP passthrough=no
  # /ip firewall mangle add action=mark-packet chain=postrouting comment=customconf: connection-mark=GAMES new-packet-mark=GAMES passthrough=no
  # /ip firewall mangle add action=mark-packet chain=postrouting comment=customconf: connection-mark=HTTP new-packet-mark=HTTP passthrough=no
  # /ip firewall mangle add action=mark-packet chain=postrouting comment=customconf: connection-mark=OTHER new-packet-mark=OTHER passthrough=no
  # /ip firewall mangle add action=mark-packet chain=postrouting comment=customconf: connection-mark=HTTP_BIG new-packet-mark=HTTP_BIG passthrough=no
  # /ip firewall mangle add action=mark-packet chain=postrouting comment=customconf: new-packet-mark=OTHER_BIG passthrough=no

  # /ip firewall nat add action=masquerade chain=srcnat comment="defconf: masquerade" ipsec-policy=out,none out-interface-list=WAN

  # /ipv6 address add address=0:0:0:1:: comment="ppoe; scarlet WAN" from-pool=scarlet interface="PPOE 1" no-dad=yes
  # /ipv6 address add from-pool=scarlet interface=bridge
  # /ipv6 dhcp-client add add-default-route=yes comment=scarlet default-route-distance=10 default-route-tables=main:10 interface="PPOE 1" pool-name=scarlet pool-prefix-length=56 request=address,prefix use-interface-duid=yes use-p
  # eer-dns=no
  # /ipv6 firewall address-list add address=::/128 comment="defconf: unspecified address" list=bad_ipv6
  # /ipv6 firewall address-list add address=::1/128 comment="defconf: lo" list=bad_ipv6
  # /ipv6 firewall address-list add address=fec0::/10 comment="defconf: site-local" list=bad_ipv6
  # /ipv6 firewall address-list add address=::ffff:0.0.0.0/96 comment="defconf: ipv4-mapped" list=bad_ipv6
  # /ipv6 firewall address-list add address=::/96 comment="defconf: ipv4 compat" list=bad_ipv6
  # /ipv6 firewall address-list add address=100::/64 comment="defconf: discard only " list=bad_ipv6
  # /ipv6 firewall address-list add address=2001:db8::/32 comment="defconf: documentation" list=bad_ipv6
  # /ipv6 firewall address-list add address=2001:10::/28 comment="defconf: ORCHID" list=bad_ipv6
  # /ipv6 firewall address-list add address=3ffe::/16 comment="defconf: 6bone" list=bad_ipv6
  # /ipv6 firewall address-list add address=::224.0.0.0/100 comment="defconf: other" list=bad_ipv6
  # /ipv6 firewall address-list add address=::127.0.0.0/104 comment="defconf: other" list=bad_ipv6
  # /ipv6 firewall address-list add address=::/104 comment="defconf: other" list=bad_ipv6
  # /ipv6 firewall address-list add address=::255.0.0.0/104 comment="defconf: other" list=bad_ipv6
  # /ipv6 firewall address-list add address=2801:1b:6000::/48 comment="customconf: LoL (Europe)" list=games
  # /ipv6 firewall address-list add address=2a04:82c0::/29 comment="customconf: LoL (Europe)" list=games
  # /ipv6 firewall address-list add address=2804:3ec0::/32 comment="customconf: LoL (Europe)" list=games
  # /ipv6 firewall filter add action=passthrough chain=input comment="debug; log ppoe ipv6" disabled=yes in-interface="PPOE 1" log=yes log-prefix=ppoe
  # /ipv6 firewall filter add action=accept chain=input comment="defconf: accept established,related" connection-state=established,related
  # /ipv6 firewall filter add action=drop chain=input comment="defconf: drop invalid" connection-state=invalid
  # /ipv6 firewall filter add action=accept chain=input comment="defconf: accept ICMPv6 after RAW" protocol=icmpv6
  # /ipv6 firewall filter add action=accept chain=input comment="defconf: accept DHCPv6-Client prefix delegation." dst-address=fe80::/10 dst-port=546 in-interface-list=WAN protocol=udp
  # /ipv6 firewall filter add action=accept chain=input comment="defconf: accept UDP traceroute" port=33434-33534 protocol=udp
  # /ipv6 firewall filter add action=drop chain=input comment="security; preventative deny all" disabled=yes
  # /ipv6 firewall filter add action=accept chain=input comment="defconf: accept IKE" disabled=yes dst-port=500,4500 protocol=udp
  # /ipv6 firewall filter add action=accept chain=input comment="defconf: accept ipsec AH" disabled=yes protocol=ipsec-ah
  # /ipv6 firewall filter add action=accept chain=input comment="defconf: accept ipsec ESP" disabled=yes protocol=ipsec-esp
  # /ipv6 firewall filter add action=drop chain=input comment="defconf: drop everything else not coming from LAN" in-interface-list=!LAN
  # /ipv6 firewall filter add action=passthrough chain=forward comment="DEBUG; log traffic" disabled=yes log=yes log-prefix="DEBUG;"
  # /ipv6 firewall filter add action=log chain=forward disabled=yes icmp-options=2:0-255 log=yes log-prefix="IPV6 PTB " protocol=icmpv6
  # /ipv6 firewall filter add action=accept chain=forward comment="defconf: accept established,related" connection-state=established,related
  # /ipv6 firewall filter add action=drop chain=forward comment="defconf: drop invalid" connection-state=invalid
  # /ipv6 firewall filter add action=drop chain=forward comment="defconf: drop packets with bad src ipv6" src-address-list=bad_ipv6
  # /ipv6 firewall filter add action=drop chain=forward comment="defconf: drop packets with bad dst ipv6" dst-address-list=bad_ipv6
  # /ipv6 firewall filter add action=drop chain=forward comment="defconf: rfc4890 drop hop-limit=1" hop-limit=equal:1 protocol=icmpv6
  # /ipv6 firewall filter add action=accept chain=forward comment="defconf: accept ICMPv6" protocol=icmpv6
  # /ipv6 firewall filter add action=drop chain=forward comment="security; preventative deny all" disabled=yes
  # /ipv6 firewall filter add action=accept chain=forward comment="defconf: accept HIP" protocol=139
  # /ipv6 firewall filter add action=accept chain=forward comment="defconf: accept IKE" disabled=yes dst-port=500,4500 protocol=udp
  # /ipv6 firewall filter add action=accept chain=forward comment="defconf: accept ipsec AH" disabled=yes protocol=ipsec-ah
  # /ipv6 firewall filter add action=accept chain=forward comment="defconf: accept ipsec ESP" disabled=yes protocol=ipsec-esp
  # /ipv6 firewall filter add action=drop chain=forward comment="defconf: drop everything else not coming from LAN" in-interface-list=!LAN
  # /ipv6 firewall mangle add action=log chain=notes comment="customconf: Start of QoS tree."
  # /ipv6 firewall mangle add action=mark-connection chain=postrouting comment="customconf: GAMES" connection-mark=no-mark dst-address-list=games new-connection-mark=GAMES passthrough=no
  # /ipv6 firewall mangle add action=mark-connection chain=postrouting comment="customconf: DNS" connection-mark=no-mark new-connection-mark=DNS passthrough=no port=53 protocol=udp
  # /ipv6 firewall mangle add action=mark-connection chain=postrouting comment="customconf: ICMP" connection-mark=no-mark new-connection-mark=ICMP passthrough=no protocol=icmp
  # /ipv6 firewall mangle add action=mark-connection chain=input comment="customconf: WINBOX" connection-mark=no-mark new-connection-mark=ICMP passthrough=no port=8291 protocol=tcp
  # /ipv6 firewall mangle add action=mark-connection chain=postrouting comment="customconf: HTTP" connection-mark=no-mark new-connection-mark=HTTP passthrough=no port=80,81,443,444,554,8000,8080,8409 protocol=tcp
  # /ipv6 firewall mangle add action=mark-connection chain=postrouting comment="customconf: QUIC" connection-mark=no-mark new-connection-mark=HTTP passthrough=no port=80,81,443,444,554,8000,8080,8409 protocol=udp
  # /ipv6 firewall mangle add action=mark-connection chain=postrouting comment="customconf: VOIP" connection-mark=no-mark connection-rate=0-100k new-connection-mark=VOIP packet-size=0-260 passthrough=no port=55000-65000 protocol=
  # udp
  # /ipv6 firewall mangle add action=mark-connection chain=postrouting comment="customconf: OTHER" connection-mark=no-mark new-connection-mark=OTHER passthrough=no protocol=tcp
  # /ipv6 firewall mangle add action=mark-connection chain=postrouting comment="customconf: OTHER" connection-mark=no-mark new-connection-mark=OTHER passthrough=no protocol=udp
  # /ipv6 firewall mangle add action=mark-connection chain=postrouting comment="customconf: HTTP BIG" connection-bytes=2000000-0 connection-mark=HTTP new-connection-mark=HTTP_BIG passthrough=no protocol=tcp
  # /ipv6 firewall mangle add action=mark-connection chain=postrouting comment="customconf: QUIC BIG" connection-bytes=2000000-0 connection-mark=HTTP new-connection-mark=HTTP_BIG passthrough=no protocol=udp
  # /ipv6 firewall mangle add action=mark-connection chain=postrouting comment="customconf: OTHER BIG" connection-bytes=500000-0 connection-mark=OTHER new-connection-mark=OTHER_BIG passthrough=no protocol=tcp
  # /ipv6 firewall mangle add action=mark-connection chain=postrouting comment="customconf: OTHER BIG" connection-bytes=500000-0 connection-mark=OTHER new-connection-mark=OTHER_BIG passthrough=no protocol=udp
  # /ipv6 firewall mangle add action=mark-connection chain=postrouting comment="customconf: OTHER BIG" connection-bytes=500000-0 connection-mark=VOIP connection-rate=200k-100M new-connection-mark=OTHER_BIG protocol=udp
  # /ipv6 firewall mangle add action=set-priority chain=postrouting comment=customconf: connection-mark=VOIP new-priority=6
  # /ipv6 firewall mangle add action=change-dscp chain=postrouting comment=customconf: connection-mark=VOIP new-dscp=48
  # /ipv6 firewall mangle add action=set-priority chain=postrouting comment=customconf: connection-mark=DNS new-priority=6
  # /ipv6 firewall mangle add action=change-dscp chain=postrouting comment=customconf: connection-mark=DNS new-dscp=48
  # /ipv6 firewall mangle add action=set-priority chain=postrouting comment=customconf: connection-mark=ICMP new-priority=6
  # /ipv6 firewall mangle add action=change-dscp chain=postrouting comment=customconf: connection-mark=ICMP new-dscp=48
  # /ipv6 firewall mangle add action=mark-packet chain=postrouting comment=customconf: new-packet-mark=ACK packet-size=0-123 passthrough=no protocol=tcp tcp-flags=ack
  # /ipv6 firewall mangle add action=mark-packet chain=postrouting comment=customconf: connection-mark=DNS new-packet-mark=DNS passthrough=no
  # /ipv6 firewall mangle add action=mark-packet chain=postrouting comment=customconf: connection-mark=ICMP new-packet-mark=ICMP passthrough=no
  # /ipv6 firewall mangle add action=mark-packet chain=postrouting comment=customconf: connection-mark=VOIP new-packet-mark=VOIP passthrough=no
  # /ipv6 firewall mangle add action=mark-packet chain=postrouting comment=customconf: connection-mark=GAMES new-packet-mark=GAMES passthrough=no
  # /ipv6 firewall mangle add action=mark-packet chain=postrouting comment=customconf: connection-mark=HTTP new-packet-mark=HTTP passthrough=no
  # /ipv6 firewall mangle add action=mark-packet chain=postrouting comment=customconf: connection-mark=OTHER new-packet-mark=OTHER passthrough=no
  # /ipv6 firewall mangle add action=mark-packet chain=postrouting comment=customconf: connection-mark=HTTP_BIG new-packet-mark=HTTP_BIG passthrough=no
  # /ipv6 firewall mangle add action=mark-packet chain=postrouting comment=customconf: new-packet-mark=OTHER_BIG passthrough=no
  # /ipv6 firewall mangle add action=change-mss chain=forward log-prefix="v6MSS clamp " new-mss=1432 protocol=tcp tcp-flags=syn
}
