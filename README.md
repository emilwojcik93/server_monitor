##Introduction

This script is used to control server power according to critical services status.
Services which are checked by script:
- qBittorrent Nox
- SMB connections
- SSH connections


## Requipments
This script is written in python3, to work properly it need interpreter and dependencies
```
sudo apt-get update && sudo apt-get install \
python3 python3-pip python3-systemd \
python3-software-properties software-properties-common \
ca-certificates tar openssh-server bash curl wget \
libsystemd-dev gcc make build-essential libc6 libstdc++6 libssl-dev libffi-dev python3-dev

sudo pip3 install systemd
```
### Installation
This script is written to execute as systemd-service. To configure it properly please follow above steps:
1. Download script to location `/opt/server_check`
```
curl -k -L 'https://raw.githubusercontent.com/emilwojcik93/server_check/main/server_check.py' -o "/opt/server_check.py" && chmod 755 "/opt/server_check.py"
```
2. Create systemd-service by executing following commnad from **root user**:
```
cat <<EOF > /lib/systemd/system/server_check.service
[Unit]
Description=Server Check Service
Wants=network.target
After=network.target

[Service]
Type=idle
ExecStart=/usr/bin/python3 /opt/server_check.py
Restart=always
TimeoutStartSec=10
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
```
3. Enable and start systemd-service by:
```
sudo systemctl daemon-reload
sudo systemctl enable server_check.service
sudo systemctl start server_check.service
```