#!/bin/sh
iface=$1
mac=$2
target=$3

tcpdump -i $iface -U -s0 dst $target | while read -r line; do
  if ! ping -q -W 1 -c 1 $target >/dev/null; then
    /usr/bin/etherwake -D -i "$iface" "$mac" 2>&1
    sleep 10
  fi
done
