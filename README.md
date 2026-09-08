# Mikrotik

## Configuration

A representative copy of my router configuration is stored inside the [config.rsc](./config.rsc) file. This file can be applied to (virtual) hardware, but all secret material has been censored. Some functions will throw an error or not have any effect without adding your own secret values.

I'm using a Mikrotik hEX (RB750Gr3) router, because Mikrotik hardware has a lot of features for a good price!


## Internet connectivity

```mermaid
flowchart LR
    A[Internet] -->|ISP Connection| B(ISP VDSL router)
    B -->|Ethernet bridge| C(Mikrotik router)
    C -->|LAN| F[fa:fa-computer Client]

```

The router is hooked up to a VDSL-to-ethernet modem, that modem has its interfaces bridged. The router terminates/manages my internet connection using the old-skool method of PPPOE. My ISP at the other end of the VDSL line performs authentication and accounting, and configures a gateway route when I login over PPPOE.

The configuration for PPPOE over IPv4 is standard; PPPOE negotiates a public IPv4 address and a gateway IP address. The IP is auto-configured on top of the PPPOE interface and a default route (0.0.0.0/0) is installed pointing at the gateway address.

The IPv6 implementation uses the modern "get IP assigned through DHCP" approach; A DHCPv6 client requests an IPv6 and an IPv6 prefix (56-bit network mask) from the ISP. In my case the received IP address is a link-local one, and the received prefix is bound into an IPv6 pool.
Because only the pool contains internet-routable IPv6 addresses I assign sub-prefixes to both the PPPOE and the bridge interfaces. The sub-prefix assigned to the bridge is also advertised to my LAN where client auto-configure their own IP. The allocation to the PPPOE interface allows the router itself to make requests to the internet (which, more specifically, will receive a routed response).
I used to need IPv6 neighbour proxying for (all) the LAN subnet(s) to make the gateway router aware of where to route my prefixes to. Since summarizing my config and reconfirming all settings I found out this isn't necessary anymore!

### Path MTU

Path Maximum Transmission Unit (MTU) discovery doesn't work correctly in my case, over the PPPOE interface. This isn't a problem for IPv4 since packets will be split and retransmitted (fragmented), but IPv6 **DOES NOT** allow fragmentation!
I have a mangle rule that clamps the TCP Maximum Segment Size (MSS) provided by clients in their SYN/SYN-ACK packets. The value itself is experimentally determined, read reproduction steps below. Also note that I only clamp inside the IPv6 firewall, there is no such operation configured in the IPv4 firewall (could be a latency optimization, but otherwise harmless).
The MSS clamp is necessary on TCP connections because the protocol has mechanisms to increase the amount of bytes sent while the connection is ongoing. The MSS value is the maximum amount of bytes it cannot exceed. Software sending data over UDP must to do their own bandwidth and latency optimization, the UDP standard doesn't have provisions for this metadata.

The maximum transmission unit accepted by the PPPOE partner can be figured out using the `ping` command.

1. Disable all MTU manipulations you might have running in your systems
1. Open a terminal prompt
1. For decrements of 10 to 0 bytes, keep pinging until you reach the ping payload size that works
	- Run IPv6 ping to eg 2001:4860:4860::8888 (google dns) with a payload size that starts from a typical MTU size of 1500 bytes
	- eg `ping -6 -n 1 -l <size: 1452> 2001:4860:4860::8888` (force IPv6, send 1 packet, set payload size)
	- Note that "payload size" = "MTU" - "IPv6 header size(40 bytes)" - "IPv6ICMP header size(8 bytes)"
		1. `ping -6 -n 1 -l 1452 2001:4860:4860::8888`
		1. `ping -6 -n 1 -l 1442 2001:4860:4860::8888`
		1. `ping -6 -n 1 -l 1432 2001:4860:4860::8888`

In my case the maximum payload size that worked is 1444.

```text
Shell> ping -6 -n 1 -l 1444 2001:4860:4860::8888

Pinging 2001:4860:4860::8888 with 1444 bytes of data:
Reply from 2001:4860:4860::8888: time=20ms

Ping statistics for 2001:4860:4860::8888:
    Packets: Sent = 1, Received = 1, Lost = 0 (0% loss),
Approximate round trip times in milli-seconds:
    Minimum = 20ms, Maximum = 20ms, Average = 20ms

Shell> ping -6 -n 1 -l 1445 2001:4860:4860::8888

Pinging 2001:4860:4860::8888 with 1445 bytes of data:
Request timed out.

Ping statistics for 2001:4860:4860::8888:
Packets: Sent = 1, Received = 0, Lost = 1 (100% loss),
```

So I configure the MSS clamp with value `1444`, because MSS represent the size of a TCP segment which also has a header size overhead of 8 bytes. The MTU is then `1444 bytes + TCP header(8 bytes) + IPv6 header(40 bytes) = 1492 bytes`. This is 8 bytes less than the typical 1500 bytes MTU, which corresponds to the 8 bytes overhead introduced by the PPPOE protocol.

**HOWEVER**, while testing connectivity using [https://test-ipv6.com/](https://test-ipv6.com/) I find I cannot connect to a couple of "Other IPv6 sites" listed. Through experimentation I found the ideal clamping value of **1432** bytes. This new value makes all HTTP connections over IPv6 go super fast while other MSS values cause connections to hang. I haven't looked into an explanation for this phenomenon.

Note that the ping test to the failing IPv6 sites just works! Yet the HTTP connections hang and timeout.. it could be browser related, or TLS1.3 0-RTT related, or HTTP3 framing related.

```text
# No clamping enabled on the router while testing
Shell> ping -6 -n 1 -l 1444 v6-only.steffann.nl

Pinging v6-only.steffann.nl [2a00:8642:1000:1::3] with 1444 bytes of data:
Reply from 2a00:8642:1000:1::3: time=21ms

Ping statistics for 2a00:8642:1000:1::3:
    Packets: Sent = 1, Received = 1, Lost = 0 (0% loss),
Approximate round trip times in milli-seconds:
    Minimum = 21ms, Maximum = 21ms, Average = 21ms
```


## Bandwidth fairness

I have a cheapo internet package which provides me without much upload/download bandwidth. To keep this internet line usable (no buffer bloat, no bandwidth hogs) in a household with many active devices I need to force bandwidth fairness.

I favour implementing this policy, concretely [bandwidth shaping](https://manual.mikrotik.com/docs/firewall-and-quality-of-service/queues/#rate-limitation-principles), through packet mangling and interface queuing. This approach is flexible and works really well if you adhere to these two rules;

1. Do not fasttrack packets, every packet must pass through the CPU to get marked for queue identification
2. It's only possible to control packets going through interfaces in the direction outward of the router.
	 eg, queue for WAN-interface controls upload bandwidth, queue for LAN-interface controls download bandwidth

The policy configuration itself is straight forward, connections are marked based on their properties like IP, port, bandwidth, total bytes processed and already set connection marks. A packet mark is set according to the connection mark, and the packet mark matches 1-on-1 with the queues. The rules are heuristics and stored inside the mangle tables (firewall).
The queues themselves act like buckets for packets, they each have a priority value and maximum size. Incoming packets exceeding the bucket size are dropped. This approach keeps latency (due to buffer bloat) low, and leaves ~guaranteed bandwidth for higher priority buckets. Buckets with higher priority (=lower priority number) get emptied first.

## DNS blocking

The router is configured to connect to the Cloudflare DNS recursive resolvers over HTTPS (DoH). The anti-malware responder is selected which isn't an average/good filter but is still useful to filter out the most obvious issues.

DNS blocking is augmented by the combo-list "fakenews", combining adware- and malware- and fakenews domains, [by Steven Black](https://github.com/StevenBlack/hosts/). This list varies in size day-by-day, I've made sure the allocated DNS-cache size is big enough to load all records.

If you add additional DNS blocklists, or some time in the future in any case, you'll need to increase this size. Run command `/ip dns print` and compare `cache-used` versus `cache-size` in your system, this will show you if you need to make your cache larger.


## What else?

I'm not sure what else to explain about this configuration. The use-case is a simple home network that shouldn't take (any) maintenance.

## Nix abstraction

Nothing that works at the moment, just some experimentation. See [nix](./nix/) folder.
Command metadata was retrieved from https://github.com/tikoci/restraml
