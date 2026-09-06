# Mikrotik

## Configuration

All configuration is stored inside the [config.rsc](./config.rsc) file.

I'm using a Mikrotik hEX (RB750Gr3) router, because Mikrotik hardware has a lot of features for a good price!


## Internet connectivity

The router is hooked up to a VDSL-to-ethernet modem, the modem has the interfaces bridged. The router terminates my internet connection using the old-skool method of PPPOE. One server at my ISP performs authentication and accounting, and configures a gateway route when I connect/login.

This isn't special over IPv4; The PPPOE interface receives a public IPv4 address and configures a default (:/0) route towards the received gateway adres.

The IPv6 implementation uses the modern "get IP assigned through DHCP" approach; A DHCPv6 client requests an IPv6 and an IPv6 prefix from the ISP. The prefix is used to distribute IPv6 IPs to clients in my home network.

### Path MTU

Path Maximum Transmission Unit (MTU) discovery doesn't work correctly over the PPPOE interface. This isn't a problem for IPv4 since packets will be fragmented, but IPv6 **DOES NOT** allow fragmentation!
I added a mangle rule that clamps the TCP Maximum Segment Size (MSS) filled in the SYN/SYN-ACK packets to a manually verified value. Manually clamping for IPv4 could be a latency optimization too, but I didn't need this implemented.

Verifying the maximum transmission unit accepted by the PPPOE partner can be found out using the `ping` command.

1. Disable all MTU manipulations you might have running in your systems
1. Open a terminal prompt
1. For decrements of 10 to 0 bytes, keep pinging until you reach the ping payload size that works
	- Run IPv6 ping to eg 2001:4860:4860::8888 (google dns) with payload size that starts from a typical 1500 bytes
	- eg `ping -6 -n 1 -l <size: 1452> 2001:4860:4860::8888` (force IPv6, send 1 packet, set payload size)
	- Note that "payload size" = "MTU" - "IPv6 header size(40 bytes)" - "IPv6ICMP header size(8 bytes)"
		1. `ping -6 -n 1 -l 1452 2001:4860:4860::8888`
		1. `ping -6 -n 1 -l 1442 2001:4860:4860::8888`
		1. `ping -6 -n 1 -l 1432 2001:4860:4860::8888`

In my case the maximum payload size that worked is 1444.

```text
BertProesmans> ping -6 -n 1 -l 1444 2001:4860:4860::8888

Pinging 2001:4860:4860::8888 with 1444 bytes of data:
Reply from 2001:4860:4860::8888: time=20ms

Ping statistics for 2001:4860:4860::8888:
    Packets: Sent = 1, Received = 1, Lost = 0 (0% loss),
Approximate round trip times in milli-seconds:
    Minimum = 20ms, Maximum = 20ms, Average = 20ms

BertProesmans> ping -6 -n 1 -l 1445 2001:4860:4860::8888

Pinging 2001:4860:4860::8888 with 1445 bytes of data:
Request timed out.

Ping statistics for 2001:4860:4860::8888:
Packets: Sent = 1, Received = 0, Lost = 1 (100% loss),
```

So I configure the MSS clamp to `1444` as well, because MSS represent the size of a TCP segment which also has a header size overhead of 8 bytes. The total MTU becomes thus `1444 bytes + TCP header(8 bytes) + IPv6 header(40 bytes) = 1492 bytes`. This is 8 bytes less than the typical 1500 bytes MTU, which corresponds to the 8 bytes overhead introduced by the PPPOE protocol.

**HOWEVER**, while testing connectivity using [https://test-ipv6.com/](https://test-ipv6.com/) I find I cannot connect to a couple of "Other IPv6 sites" listed. Through experimentation I found the ideal clamping value of **1432** bytes. This new value makes all HTTP connections over IPv6 go super fast while other MSS values cause connections to hang. I haven't found the exact theoretical explanation for this phenomenon.

Note that the ping test to one of the failing IPv6 sites just works! Yet the HTTP connections hang and timeout..

```text
# No clamping enabled on the router while testing
BertProesmans> ping -6 -n 1 -l 1444 v6-only.steffann.nl

Pinging v6-only.steffann.nl [2a00:8642:1000:1::3] with 1444 bytes of data:
Reply from 2a00:8642:1000:1::3: time=21ms

Ping statistics for 2a00:8642:1000:1::3:
    Packets: Sent = 1, Received = 1, Lost = 0 (0% loss),
Approximate round trip times in milli-seconds:
    Minimum = 21ms, Maximum = 21ms, Average = 21ms
```


## Bandwidth fairness

I have a cheapo internet package which provides me without much upload/download bandwidth. To keep this internet line usable (no buffer bloat, no bandwidth hogs) in a household with many active devices I needed to force fairness inside the router.

The bandwidth fairness is configured through queue trees. The configuration takes an upper value for upload and download bandwidth, together with buckets for internet packets that each have their assigned priority. The buckets are filled with packets that are marked through firewall mangle rules. Higher priority (=lower priority number) buckets are emptied first.
Internet packets are identified using connection-marks, using simple heuristics like destination IP and/or packet protocol, size, bandwidth rate.



## Nix abstraction

See [nix](./nix/) folder.

Command metadata from https://github.com/tikoci/restraml
