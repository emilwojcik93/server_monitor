## Introduction

This script is used to control server power according to status of critical services:
- qBittorrent Nox
- SMB connections
- SSH connections


## Requipments
These scripts require :
#### Server side
Script is written in python3, to work properly it need interpreter and dependencies
```
sudo apt-get update && sudo apt-get install python3 python3-pip curl nano
```
#### OpenWRT router side
Script is writen to check output of TCPdump and inotifywait:
```
opkg update && opkg install tcpdump inotifywait
```
## Installation

### Auto installation
Those oneliners below download needed dependencies and setting them up:
#### Server side (server_check)
```
curl -k -L 'https://raw.githubusercontent.com/emilwojcik93/server_monitor/main/autoinstall-server_check.sh' -o "/tmp/autoinstall.sh" && chmod 755 "/tmp/autoinstall.sh" && /tmp/autoinstall.sh && rm /tmp/autoinstall.sh
```
#### OpenWRT router side (server_start)
```
opkg update && opkg install curl && curl -k -L 'https://raw.githubusercontent.com/emilwojcik93/server_monitor/main/autoinstall-server_start.sh' -o "/tmp/autoinstall.sh" && chmod 755 "/tmp/autoinstall.sh" && /tmp/autoinstall.sh && rm /tmp/autoinstall.sh
```
### Manual installation
#### Server Side (server_check)
This script is written to execute as systemd-service. To configure it properly please follow above steps:
1. Download script to location `/opt/server_check.py`
```
sudo curl -k -L 'https://raw.githubusercontent.com/emilwojcik93/server_monitor/main/server_check.py' -o "/opt/server_check.py" && sudo chmod 755 "/opt/server_check.py"
```
2. Create systemd service by executing following commnad from **root user**:

   Please change value of arguments `<user>` and `<pass>` in `ExecStart` (line 8)
```
sudo curl -k -L 'https://raw.githubusercontent.com/emilwojcik93/server_monitor/main/server_check.service' -o "/lib/systemd/system/server_check.service"
```
3. Enable and start systemd-service by:
```
sudo systemctl daemon-reload
sudo systemctl enable server_check.service
sudo systemctl start server_check.service
sudo systemctl status server_check.service
```

#### OpenWRT router side (server_start)
1. Download script to location `/bin/server-start.sh`
```
curl -k -L 'https://raw.githubusercontent.com/emilwojcik93/server_monitor/main/openwrt/server-start.sh' -o "/bin/server-start.sh" && chmod 755 "/bin/server-start.sh"
```
2.  Create init.d service by executing following commnad:
```
curl -k -L 'https://raw.githubusercontent.com/emilwojcik93/server_monitor/main/openwrt/server-start' -o "/etc/init.d/server-start" && chmod 755 "/etc/init.d/server-start"
```
3. Enable and start systemd-service by:
```
/etc/init.d/server-start start && \
/etc/init.d/server-start enable && \
ps | grep server-start | grep -v grep
```
