#!/bin/sh
iface=$1
mac=$2
while true; do
  while inotifywait -e modify /var/log/nginx/access.log; do
    if tail -n1 /var/log/nginx/access.log | grep 502; then
      echo "/usr/bin/etherwake -D -i '$iface' "$mac" 2>&1"
      sleep 5
    fi
  done
done
