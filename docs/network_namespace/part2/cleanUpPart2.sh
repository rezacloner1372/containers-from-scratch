#!/bin/bash
ip link delete dev host_bridge
ip link delete dev host1_veth
ip link delete dev host2_veth
ip netns delete apple_ns
ip netns delete lemon_ns
iptables --delete FORWARD -i host_bridge -o enp0s3 -j ACCEPT
iptables --delete FORWARD -i enp0s3 -o host_bridge -j ACCEPT
iptables --delete POSTROUTING -t nat -o enp0s3 -j MASQUERADE
