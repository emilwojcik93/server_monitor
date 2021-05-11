#!/bin/sh
while true; do
  while inotifywait -e modify /var/log/nginx/access.log; do
    if tail -n1 /var/log/nginx/access.log | grep 502; then
      /usr/bin/etherwake -D -i 'wlan1.sta1' "50:57:A8:E1:44:6B" 2>&1
      sleep 5
    fi
  done
done
