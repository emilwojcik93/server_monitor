#!/bin/sh
iface=$1
skip_ip_addr=$2
target=$3
mac=$4

function finish {
  killall tcpdump >/dev/null
  killall inotifywait >/dev/null
  exit 0
}

function tcp_check {
  if ! pgrep -x tcpdump >/dev/null; then
    tcpdump -i $iface -U -s0 not src host $skip_ip_addr and not icmp and not src host $skip_ip_addr and arp and dst host $target | while read -r line; do
      killall tcpdump >/dev/null
      return $(true)
    done
  else
    killall tcpdump >/dev/null
    return $(false)
  fi
}

function domain_check {
  if ! pgrep -x inotifywait >/dev/null; then
    while inotifywait -e modify /var/log/nginx/access.log; do
      if tail -n1 /var/log/nginx/access.log | grep 502; then
        killall inotifywait >/dev/null
        return $(true)
      fi
    done
  else
    killall inotifywait >/dev/null
    return $(false)
  fi
}

while ! ping -q -W 1 -c 1 $target >/dev/null; do
  if tcp_check; then
    echo "/usr/bin/etherwake -D -i "$iface" "$mac" 2>&1"
#    sleep 10
  fi &
  if domain_check; then
    echo "/usr/bin/etherwake -D -i "$iface" "$mac" 2>&1"
#    sleep 10
  fi &
done


# Execute finish function on CTRL+C
trap finish SIGINT

# Execute finish function on EXIT
trap finish EXIT
