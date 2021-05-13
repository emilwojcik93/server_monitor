#!/bin/sh
iface=$1
skip_ip_addr=$2
target=$3
mac=$4

tcpdump -i $iface -U -s0 not src host $skip_ip_addr and not icmp and dst host $target | while read -r line; do
  if ! ping -q -W 1 -c 1 $target >/dev/null; then
    /usr/bin/etherwake -D -i "$iface" "$mac" 2>&1
    sleep 10
  fi
done

