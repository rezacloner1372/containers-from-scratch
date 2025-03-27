#!/bin/bash
# Create a veth pair: one end in the host, the other in the namespace
ip link add dev host2_veth type veth peer name lemon_veth

# Bring up the host-side interface
ip link set dev host2_veth up
ip address add 10.0.0.20/24 dev host2_veth

# Create the namespace
ip netns add lemon_ns

# Move the veth pair inside the namespace
ip link set dev lemon_veth netns lemon_ns

# Configure the namespace network
ip netns exec lemon_ns ip link set dev lo up
ip netns exec lemon_ns ip link set dev lemon_veth up
ip netns exec lemon_ns ip address add 10.0.0.21/24 dev lemon_veth
ip netns exec lemon_ns ip route add default via 10.0.0.20

# Start a simple HTTP server in the namespace
ip netns exec lemon_ns python3 -m http.server 8080 &
