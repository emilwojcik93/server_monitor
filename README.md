## Introduction

This script is used to control server power according to status of critical services:
- qBittorrent Nox
- SMB connections
- SSH connections


## Requipments
This script is written in python3, to work properly it need interpreter and dependencies
```
sudo apt-get update && sudo apt-get install python3 python3-pip curl nano
```
## Installation

## Auto installation
This oneliner below download needed dependencies and setting them up:
   Server side -- server_check:
```
sudo true && \
sudo curl -k -L 'https://raw.githubusercontent.com/emilwojcik93/server_check/main/server_check.py' -o "/opt/server_check.py" && sudo chmod 755 "/opt/server_check.py" && \
sudo curl -k -L 'https://raw.githubusercontent.com/emilwojcik93/server_check/main/server_check.service' -o "/lib/systemd/system/server_check.service" && \
echo -e "Please change <user> <pass> in ExecStart (line 8)\nThen press CTRL+x, then Enter" && \
sleep 5 && \
sudo nano /lib/systemd/system/server_check.service && \
sudo systemctl daemon-reload && \
sudo systemctl enable server_check.service && \
sudo systemctl start server_check.service
```
   Router side -- server_start:
```
curl -k -L 'https://raw.githubusercontent.com/emilwojcik93/server_check/main/server-start.sh' -o "/bin/server-start.sh" && sudo chmod 755 "/bin/server-start.sh" && \
curl -k -L 'https://raw.githubusercontent.com/emilwojcik93/server_check/main/server-start' -o "/etc/init.d/server-start" && \
/etc/init.d/server-start start
```
### Manual installation
This script is written to execute as systemd-service. To configure it properly please follow above steps:
1. Download script to location `/opt/server_check`
```
sudo curl -k -L 'https://raw.githubusercontent.com/emilwojcik93/server_check/main/server_check.py' -o "/opt/server_check.py" && sudo chmod 755 "/opt/server_check.py"
```
2. Edit values of credentials variables `username` and `password` in function `empty_downloads` (line 32).
3. Create systemd-service by executing following commnad from **root user**:

   Please change `<user> <pass>` in `ExecStart` (line 8)
```
sudo curl -k -L 'https://raw.githubusercontent.com/emilwojcik93/server_check/main/server_check.service' -o "/lib/systemd/system/server_check.service"
```
4. Enable and start systemd-service by:
```
sudo systemctl daemon-reload
sudo systemctl enable server_check.service
sudo systemctl start server_check.service
```
