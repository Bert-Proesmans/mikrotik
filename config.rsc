# 2026-09-06 19:51:21 by RouterOS 7.23.1
#
# model = RB750Gr3

/user
  add name=bertp group=full comment=customconf
# disable "admin"

/system clock    set time-zone-name=Europe/Brussels
/system identity set name=A-Proesmans
/system logging  set 0 topics=info,!dhcp
/system note
  set note="ALPHA Proesmans EDGE router"
  set show-at-cli-login=yes show-at-login=no

/interface list
  add name=WAN comment=defconf
  add name=LAN comment=defconf
/interface list member add interface=ether1 list=WAN comment=defconf


/interface bridge
  add name=bridge comment=defconf \
    admin-mac=B8:69:F4:55:24:31  auto-mac=no port-cost-mode=short
/interface list member add interface=bridge list=LAN comment=defconf
/queue interface set "bridge" queue=no-queue

/interface bridge port
  add bridge=bridge interface=ether2 comment=defconf \
    ingress-filtering=no internal-path-cost=10 path-cost=10
  add bridge=bridge interface=ether3 comment=defconf \
    ingress-filtering=no internal-path-cost=10 path-cost=10
  add bridge=bridge interface=ether4 comment=defconf \
    ingress-filtering=no internal-path-cost=10 path-cost=10
  add bridge=bridge interface=ether5 comment=defconf \
    ingress-filtering=no internal-path-cost=10 path-cost=10


/interface pppoe-client
  add name="PPOE 1" comment=customconf \
    add-default-route=yes default-route-distance=11 interface=ether1 user="<omitted>" password="<omitted>"
/interface list member add interface="PPOE 1" list=WAN comment=customconf
/queue interface set "PPOE 1" queue=no-queue


/queue type
  add name=default-sfq   kind=sfq
  add name=red-download  kind=red \
    red-avg-packet=1500 red-burst=10 red-limit=40 red-max-threshold=40
  add name=red-upload    kind=red \
    red-avg-packet=1500 red-burst=5  red-limit=20 red-max-threshold=20 red-min-threshold=5
  set "pcq-upload-default"   pcq-rate=5M  pcq-total-limit=25000KiB
  set "pcq-download-default" pcq-rate=40M pcq-total-limit=25000KiB

/queue tree
  add name="customconf: TOTAL_UP" parent="PPOE 1" queue=default max-limit=15M
  add name="customconf: TOTAL_DOWN" parent=bridge queue=default max-limit=45M
  add name=ACK_U        parent="customconf: TOTAL_UP"    limit-at=1500k  max-limit=15M  packet-mark=ACK        priority=1 queue=default
  add name=VOIP_U       parent="customconf: TOTAL_UP"    limit-at=1500k  max-limit=15M  packet-mark=VOIP       priority=2 queue=default
  add name=GAMES_U      parent="customconf: TOTAL_UP"    limit-at=1500k  max-limit=15M  packet-mark=GAMES      priority=3 queue=default-sfq
  add name=DNS_U        parent="customconf: TOTAL_UP"    limit-at=1500k  max-limit=15M  packet-mark=DNS        priority=4 queue=default
  add name=ICMP_U       parent="customconf: TOTAL_UP"    limit-at=1500k  max-limit=15M  packet-mark=ICMP       priority=5 queue=default
  add name=HTTP_U       parent="customconf: TOTAL_UP"    limit-at=100k   max-limit=5M   packet-mark=HTTP       priority=6 queue=pcq-upload-default
  add name=HTTP_U_BIG   parent="customconf: TOTAL_UP"    limit-at=100k   max-limit=5M   packet-mark=HTTP_BIG   priority=7 queue=pcq-upload-default
  add name=OTHER_U      parent="customconf: TOTAL_UP"    limit-at=100k   max-limit=5M   packet-mark=OTHER                 queue=red-upload
  add name=OTHER_U_BIG  parent="customconf: TOTAL_UP"    limit-at=100k   max-limit=5M   packet-mark=OTHER_BIG             queue=red-upload

  add name=ACK_D        parent="customconf: TOTAL_DOWN"  limit-at=4M     max-limit=45M  packet-mark=ACK        priority=1 queue=default
  add name=VOIP_D       parent="customconf: TOTAL_DOWN"  limit-at=4M     max-limit=45M  packet-mark=VOIP       priority=2 queue=default
  add name=GAMES_D      parent="customconf: TOTAL_DOWN"  limit-at=4M     max-limit=45M  packet-mark=GAMES      priority=3 queue=default
  add name=DNS_D        parent="customconf: TOTAL_DOWN"  limit-at=4M     max-limit=45M  packet-mark=DNS        priority=4 queue=default
  add name=ICMP_D       parent="customconf: TOTAL_DOWN"  limit-at=4M     max-limit=45M  packet-mark=ICMP       priority=5 queue=default
  add name=HTTP_D       parent="customconf: TOTAL_DOWN"  limit-at=250k   max-limit=45M  packet-mark=HTTP       priority=6 queue=pcq-download-default
  add name=HTTP_D_BIG   parent="customconf: TOTAL_DOWN"  limit-at=250k   max-limit=40M  packet-mark=HTTP_BIG   priority=7 queue=pcq-download-default
  add name=OTHER_D      parent="customconf: TOTAL_DOWN"  limit-at=250k   max-limit=45M  packet-mark=OTHER                 queue=red-download
  add name=OTHER_D_BIG  parent="customconf: TOTAL_DOWN"  limit-at=250k   max-limit=40M  packet-mark=OTHER_BIG             queue=red-download


/ip settings
  set rp-filter=strict
  set allow-fast-path=no
/ipv6 settings
  set accept-redirects=no accept-router-advertisements=no accept-router-advertisements-on=none
  set allow-fast-path=no
/ip neighbor discovery-settings
  set discover-interface-list=LAN

/ip service
  set ftp           disabled=yes
  set telnet        disabled=yes
  set www           disabled=yes
  set api           disabled=yes
  set api-ssl       disabled=yes
  set reverse-proxy disabled=yes
  set ssh     address=192.168.88.0/24
  set winbox  address=192.168.88.0/24


/ip pool
  add name=default-dhcp ranges=192.168.88.10-192.168.88.254

/ip address
  add address=192.168.88.1/24 comment=defconf \
    interface=bridge network=192.168.88.0

/ipv6 address
  add address=0:0:0:1:: interface="PPOE 1" comment="ppoe; scarlet WAN" \
    from-pool=scarlet no-dad=yes
  add from-pool=scarlet interface=bridge

/ipv6 nd set [ find default=yes ] disabled=yes
/ipv6 nd
  add interface="PPOE 1"
  add interface="bridge" ra-preference=high advertise-dns=self managed-address-configuration=yes
# TODO; Not sure if this is needed anymore?
#/ipv6 nd proxy
#  add interface="PPOE 1" address=2a02:a03f:971f:1f00:: comment="workaround; missing DUID scarlet"


/ip firewall connection tracking
  set udp-timeout=10s

/ip firewall service-port
  set ftp     disabled=yes
  set tftp    disabled=yes
  set h323    disabled=yes
  set sip     disabled=yes
  set pptp    disabled=yes
  set udplite disabled=yes
  set dccp    disabled=yes
  set sctp    disabled=yes

# NOTE; See file address-lists.rsc for IPs of game servers

/ipv6 firewall address-list
  add list=bad_ipv6 address=::/128            comment="defconf: unspecified address"
  add list=bad_ipv6 address=::1/128           comment="defconf: lo"
  add list=bad_ipv6 address=fec0::/10         comment="defconf: site-local"
  add list=bad_ipv6 address=::ffff:0.0.0.0/96 comment="defconf: ipv4-mapped"
  add list=bad_ipv6 address=::/96             comment="defconf: ipv4 compat"
  add list=bad_ipv6 address=100::/64          comment="defconf: discard only "
  add list=bad_ipv6 address=2001:db8::/32     comment="defconf: documentation"
  add list=bad_ipv6 address=2001:10::/28      comment="defconf: ORCHID"
  add list=bad_ipv6 address=3ffe::/16         comment="defconf: 6bone"
  add list=bad_ipv6 address=::224.0.0.0/100   comment="defconf: other"
  add list=bad_ipv6 address=::127.0.0.0/104   comment="defconf: other"
  add list=bad_ipv6 address=::/104            comment="defconf: other"
  add list=bad_ipv6 address=::255.0.0.0/104   comment="defconf: other"

/ip firewall mangle
  add chain=input action=mark-connection connection-mark=no-mark new-connection-mark=ICMP passthrough=no protocol=tcp port=8291 comment="customconf: WINBOX"
/ip firewall filter
  add chain=input action=accept connection-state=established,related,untracked comment="defconf: accept established,related,untracked"
  add chain=input action=drop   connection-state=invalid                       comment="defconf: drop invalid"
  add chain=input action=accept protocol=icmp                                  comment="defconf: accept ICMP"
  add chain=input action=accept disabled=yes
  add chain=input action=drop   in-interface-list=!LAN                         comment="defconf: drop all not coming from LAN"

/ip firewall nat
  add chain=srcnat action=masquerade out-interface-list=WAN comment="defconf: masquerade"

/ip firewall filter
  add chain=forward action=accept connection-state=established,related                                    comment="defconf: accept established,related"
  add chain=forward action=drop   connection-state=invalid                                                comment="defconf: drop invalid"
  add chain=forward action=drop   connection-state=new connection-nat-state=!dstnat in-interface-list=WAN comment="defconf: drop all from WAN not DSTNATed"
  add chain=forward action=drop   connection-state=""  in-interface-list=!LAN                             comment="DROP all"

/ip firewall mangle
  add chain=postrouting action=mark-connection  connection-mark=no-mark  new-connection-mark=GAMES     passthrough=no               dst-address-list=games comment="customconf: GAMES"
  add chain=postrouting action=mark-connection  connection-mark=no-mark  new-connection-mark=ICMP      passthrough=no protocol=icmp comment="customconf: ICMP"
  add chain=postrouting action=mark-connection  connection-mark=no-mark  new-connection-mark=OTHER     passthrough=no protocol=tcp  comment="customconf: OTHER"
  add chain=postrouting action=mark-connection  connection-mark=no-mark  new-connection-mark=OTHER     passthrough=no protocol=udp  comment="customconf: OTHER"
  add chain=postrouting action=mark-connection  connection-mark=no-mark  new-connection-mark=DNS       passthrough=no protocol=udp  port=53 comment="customconf: DNS"
  add chain=postrouting action=mark-connection  connection-mark=no-mark  new-connection-mark=HTTP      passthrough=no protocol=tcp  port=80,81,443,444,554,8000,8080,8409 comment="customconf: HTTP"
  add chain=postrouting action=mark-connection  connection-mark=no-mark  new-connection-mark=HTTP      passthrough=no protocol=udp  port=80,81,443,444,554,8000,8080,8409 comment="customconf: QUIC"
  add chain=postrouting action=mark-connection  connection-mark=no-mark  new-connection-mark=VOIP      passthrough=no protocol=udp  port=55000-65000 connection-rate=0-100k packet-size=0-260 comment="customconf: VOIP"
  add chain=postrouting action=mark-connection  connection-mark=HTTP     new-connection-mark=HTTP_BIG  passthrough=no protocol=tcp  connection-bytes=2000000-0 comment="customconf: HTTP BIG"
  add chain=postrouting action=mark-connection  connection-mark=HTTP     new-connection-mark=HTTP_BIG  passthrough=no protocol=udp  connection-bytes=2000000-0 comment="customconf: QUIC BIG"
  add chain=postrouting action=mark-connection  connection-mark=OTHER    new-connection-mark=OTHER_BIG passthrough=no protocol=tcp  connection-bytes=500000-0  comment="customconf: OTHER BIG"
  add chain=postrouting action=mark-connection  connection-mark=OTHER    new-connection-mark=OTHER_BIG passthrough=no protocol=udp  connection-bytes=500000-0  comment="customconf: OTHER BIG"
  add chain=postrouting action=mark-connection  connection-mark=VOIP     new-connection-mark=OTHER_BIG passthrough=no protocol=udp  connection-bytes=500000 connection-rate=200k-100M  comment="customconf: OTHER BIG"
  add chain=postrouting action=set-priority     connection-mark=VOIP     new-priority=6 comment="customconf:"
  add chain=postrouting action=set-priority     connection-mark=DNS      new-priority=6 comment="customconf:"
  add chain=postrouting action=set-priority     connection-mark=ICMP     new-priority=6 comment="customconf:"
  add chain=postrouting action=change-dscp      connection-mark=VOIP     new-dscp=48    comment="customconf:"
  add chain=postrouting action=change-dscp      connection-mark=DNS      new-dscp=48    comment="customconf:"
  add chain=postrouting action=change-dscp      connection-mark=ICMP     new-dscp=48    comment="customconf:"
  add chain=postrouting action=mark-packet      connection-mark=DNS      new-packet-mark=DNS       passthrough=no                                               comment="customconf:"
  add chain=postrouting action=mark-packet      connection-mark=ICMP     new-packet-mark=ICMP      passthrough=no                                               comment="customconf:"
  add chain=postrouting action=mark-packet      connection-mark=VOIP     new-packet-mark=VOIP      passthrough=no                                               comment="customconf:"
  add chain=postrouting action=mark-packet      connection-mark=GAMES    new-packet-mark=GAMES     passthrough=no                                               comment="customconf:"
  add chain=postrouting action=mark-packet      connection-mark=HTTP     new-packet-mark=HTTP      passthrough=no                                               comment="customconf:"
  add chain=postrouting action=mark-packet      connection-mark=OTHER    new-packet-mark=OTHER     passthrough=no                                               comment="customconf:"
  add chain=postrouting action=mark-packet      connection-mark=HTTP_BIG new-packet-mark=HTTP_BIG  passthrough=no                                               comment="customconf:"
  add chain=postrouting action=mark-packet                               new-packet-mark=ACK       passthrough=no packet-size=0-123 protocol=tcp tcp-flags=ack  comment="customconf:"
  add chain=postrouting action=mark-packet                               new-packet-mark=OTHER_BIG passthrough=no                                               comment="customconf:"


/ipv6 firewall mangle
  add chain=input action=mark-connection connection-mark=no-mark new-connection-mark=ICMP passthrough=no protocol=tcp port=8291 comment="customconf: WINBOX"
/ipv6 firewall filter
  add chain=input disabled=yes action=passthrough in-interface="PPOE 1" log=yes log-prefix=ppoe comment="debug; log ppoe ipv6"
  add chain=input action=accept  connection-state=established,related comment="defconf: accept established,related"
  add chain=input action=drop    connection-state=invalid             comment="defconf: drop invalid"
  add chain=input action=accept  protocol=icmpv6                      comment="defconf: accept ICMPv6 after RAW"
  add chain=input action=accept  protocol=udp dst-address=fe80::/10 dst-port=546 in-interface-list=WAN  comment="defconf: accept DHCPv6-Client prefix delegation."
  add chain=input action=accept  protocol=udp port=33434-33534            comment="defconf: accept UDP traceroute"
  add chain=input disabled=yes action=drop                                             comment="security; preventative deny all"
  add chain=input disabled=yes action=accept  protocol=udp dst-port=500,4500           comment="defconf: accept IKE"
  add chain=input disabled=yes action=accept  protocol=ipsec-ah                        comment="defconf: accept ipsec AH"
  add chain=input disabled=yes action=accept  protocol=ipsec-esp                       comment="defconf: accept ipsec ESP"
  add chain=input action=drop    in-interface-list=!LAN                   comment="defconf: drop everything else not coming from LAN"

/ipv6 firewall filter
  add chain=forward disabled=yes action=passthrough log=yes log-prefix="debug; log ipv6" comment="debug; log traffic"
  add chain=forward action=accept connection-state=established,related  comment="defconf: accept established,related"
  add chain=forward action=drop   connection-state=invalid              comment="defconf: drop invalid"
  add chain=forward action=drop   src-address-list=bad_ipv6             comment="defconf: drop packets with bad src ipv6"
  add chain=forward action=drop   dst-address-list=bad_ipv6             comment="defconf: drop packets with bad dst ipv6"
  add chain=forward action=drop   protocol=icmpv6 hop-limit=equal:1     comment="defconf: rfc4890 drop hop-limit=1"
  add chain=forward action=accept protocol=icmpv6                       comment="defconf: accept ICMPv6"
  add chain=forward disabled=yes action=drop                                         comment="security; preventative deny all"
  add chain=forward disabled=yes action=accept protocol=139                          comment="defconf: accept HIP"
  add chain=forward disabled=yes action=accept protocol=udp dst-port=500,4500        comment="defconf: accept IKE"
  add chain=forward disabled=yes action=accept protocol=ipsec-ah                     comment="defconf: accept ipsec AH"
  add chain=forward disabled=yes action=accept protocol=ipsec-esp                    comment="defconf: accept ipsec ESP"
  add chain=forward action=drop   in-interface-list=!LAN                comment="defconf: drop everything else not coming from LAN"


/ipv6 firewall mangle
  add chain=forward     action=change-mss protocol=tcp tcp-flags=syn new-mss=1432 comment="v6MSS clamp for PPPOE tunnel"
  add chain=postrouting action=mark-connection connection-mark=no-mark  new-connection-mark=GAMES     passthrough=no dst-address-list=games  comment="customconf: GAMES"
  add chain=postrouting action=mark-connection connection-mark=no-mark  new-connection-mark=DNS       passthrough=no protocol=udp port=53     comment="customconf: DNS"
  add chain=postrouting action=mark-connection connection-mark=no-mark  new-connection-mark=ICMP      passthrough=no protocol=icmp            comment="customconf: ICMP"
  add chain=postrouting action=mark-connection connection-mark=no-mark  new-connection-mark=HTTP      passthrough=no protocol=tcp port=80,81,443,444,554,8000,8080,8409 comment="customconf: HTTP"
  add chain=postrouting action=mark-connection connection-mark=no-mark  new-connection-mark=HTTP      passthrough=no protocol=udp port=80,81,443,444,554,8000,8080,8409 comment="customconf: QUIC"
  add chain=postrouting action=mark-connection connection-mark=no-mark  new-connection-mark=VOIP      passthrough=no protocol=udp port=55000-65000 connection-rate=0-100k packet-size=0-260 comment="customconf: VOIP"
  add chain=postrouting action=mark-connection connection-mark=no-mark  new-connection-mark=OTHER     passthrough=no protocol=tcp comment="customconf: OTHER"
  add chain=postrouting action=mark-connection connection-mark=no-mark  new-connection-mark=OTHER     passthrough=no protocol=udp comment="customconf: OTHER"
  add chain=postrouting action=mark-connection connection-mark=HTTP     new-connection-mark=HTTP_BIG  passthrough=no protocol=tcp connection-bytes=2000000-0 comment="customconf: HTTP BIG"
  add chain=postrouting action=mark-connection connection-mark=HTTP     new-connection-mark=HTTP_BIG  passthrough=no protocol=udp connection-bytes=2000000-0 comment="customconf: QUIC BIG"
  add chain=postrouting action=mark-connection connection-mark=OTHER    new-connection-mark=OTHER_BIG passthrough=no protocol=tcp connection-bytes=500000-0  comment="customconf: OTHER BIG"
  add chain=postrouting action=mark-connection connection-mark=OTHER    new-connection-mark=OTHER_BIG passthrough=no protocol=udp connection-bytes=500000-0  comment="customconf: OTHER BIG"
  add chain=postrouting action=mark-connection connection-mark=VOIP     new-connection-mark=OTHER_BIG                protocol=udp connection-bytes=500000-0  connection-rate=200k-100M comment="customconf: OTHER BIG"
  add chain=postrouting action=set-priority    connection-mark=VOIP     new-priority=6 comment=customconf:
  add chain=postrouting action=set-priority    connection-mark=DNS      new-priority=6 comment=customconf:
  add chain=postrouting action=set-priority    connection-mark=ICMP     new-priority=6 comment=customconf:
  add chain=postrouting action=change-dscp     connection-mark=VOIP     new-dscp=48    comment=customconf:
  add chain=postrouting action=change-dscp     connection-mark=DNS      new-dscp=48    comment=customconf:
  add chain=postrouting action=change-dscp     connection-mark=ICMP     new-dscp=48    comment=customconf:
  add chain=postrouting action=mark-packet     connection-mark=DNS      new-packet-mark=DNS           passthrough=no comment=customconf:
  add chain=postrouting action=mark-packet     connection-mark=ICMP     new-packet-mark=ICMP          passthrough=no comment=customconf:
  add chain=postrouting action=mark-packet     connection-mark=VOIP     new-packet-mark=VOIP          passthrough=no comment=customconf:
  add chain=postrouting action=mark-packet     connection-mark=GAMES    new-packet-mark=GAMES         passthrough=no comment=customconf:
  add chain=postrouting action=mark-packet     connection-mark=HTTP     new-packet-mark=HTTP          passthrough=no comment=customconf:
  add chain=postrouting action=mark-packet     connection-mark=OTHER    new-packet-mark=OTHER         passthrough=no comment=customconf:
  add chain=postrouting action=mark-packet     connection-mark=HTTP_BIG new-packet-mark=HTTP_BIG      passthrough=no comment=customconf:
  add chain=postrouting action=mark-packet                              new-packet-mark=ACK           passthrough=no protocol=tcp tcp-flags=ack packet-size=0-123 comment=customconf:
  add chain=postrouting action=mark-packet                              new-packet-mark=OTHER_BIG     passthrough=no comment=customconf:


/ip dhcp-server
  add name=defconf interface=bridge address-pool=default-dhcp lease-time=3h
/ip dhcp-server network
  add address=192.168.88.0/24 comment=defconf dns-server=192.168.88.1 gateway=192.168.88.1

/ip dhcp-server lease
  add address=192.168.88.4  mac-address=94:83:C4:B0:9C:A7 server=defconf comment="Flint3"
  add address=192.168.88.11 mac-address=B4:2E:99:15:33:A6 server=defconf comment="Hypervisor ALPHA"

/ipv6 dhcp-client
  add interface="PPOE 1" comment=scarlet \
    pool-name=scarlet      pool-prefix-length=56 \
    request=address,prefix use-interface-duid=yes     use-peer-dns=no \
    add-default-route=yes  default-route-distance=10 default-route-tables=main:10


/ip dns
  set use-doh-server=https://security.cloudflare-dns.com/dns-query verify-doh-cert=yes
  set cache-size=9216KiB
  set allow-remote-requests=yes
/ip dns adlist
  add url=https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews/hosts
/ip dns static
  add name=router.lan                         type=A    address=192.168.88.1          comment=defconf
  add name=security.cloudflare-dns.com        type=A    address=1.1.1.2               comment="bootstrap DNS"
  add name=security.cloudflare-dns.com        type=AAAA address=2606:4700:4700::1112  comment="bootstrap DNS"
  add name=buddy.internal.proesmans.eu        type=A    address=192.168.88.11         comment="use buddy.local instead"
  add name=development.internal.proesmans.eu  type=AAAA address=fe80::139             comment="use development.local instead"
  add name=alpha.pictures.proesmans.eu        type=A    address=192.168.88.11


/system script
  add name=wake_buddy comment="Wake Alpha buddy" \
    dont-require-permissions=no owner=bertp policy=test \
    source="/tool wol interface=bridge mac=B4:2E:99:15:33:A6\n/tool wol interface=bridge mac=B4:2E:99:15:33:A6\n/tool wol interface=bridge mac=B4:2E:99:15:33:A6"
/system scheduler
  add name="Daily evening" comment="WOL Alpha buddy" \
    interval=1d on-event=wake_buddy policy=test start-date=2026-06-08 start-time=18:30:00

/tool mac-server            set allowed-interface-list=LAN
/tool mac-server mac-winbox set allowed-interface-list=LAN
/tool bandwidth-server      set enabled=no
