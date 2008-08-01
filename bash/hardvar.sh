#!/bin/bash
# tap-setup.sh

# Change username accordingly
USER="username_here"

tap_up(){
tunctl -u $USER
sysctl net.ipv4.ip_forward=1
sysctl net.ipv4.conf.wlan0.proxy_arp=1
sysctl net.ipv4.conf.tap0.proxy_arp=1
ip link set tap0 up
route add -host 192.168.1.200 dev tap0
}