#!/bin/bash
# Create a veth pair: one end in the host, the other in the namespace
ip link add dev host1_veth type veth peer name apple_veth

# Bring up the host-side interface
ip link set dev host1_veth up
ip address add 10.0.0.10/24 dev host1_veth

# Create the namespace
ip netns add apple_ns

# Move the veth pair inside the namespace
ip link set dev apple_veth netns apple_ns

# Configure the namespace network
ip netns exec apple_ns ip link set dev lo up
ip netns exec apple_ns ip link set dev apple_veth up
ip netns exec apple_ns ip address add 10.0.0.11/24 dev apple_veth
ip netns exec apple_ns ip route add default via 10.0.0.10

# Start a simple HTTP server in the namespace
ip netns exec apple_ns python3 -m http.server 8080 &
