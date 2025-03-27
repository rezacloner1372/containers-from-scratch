#!/bin/bash
ip link delete dev host_veth
ip netns del apple_ns
iptables --delete FORWARD -i host_veth -o enp0s3 -j ACCEPT
iptables --delete FORWARD -i enp0s3 -o host_veth -j ACCEPT
iptables --delete POSTROUTING -t nat -o enp0s3 -j MASQUERADE
