echo "Enter qBittorrent NOX user: "  
read user
echo "Enter qBittorrent NOX password: "  
read pass

# Script only works if sudo caches the password for a few minutes
sudo true && \
sudo curl -k -L 'https://raw.githubusercontent.com/emilwojcik93/server_monitor/main/server_check.py' -o "/opt/server_check.py" && sudo chmod 755 "/opt/server_check.py" && \
sudo curl -k -L 'https://raw.githubusercontent.com/emilwojcik93/server_monitor/main/server_check.service' -o "/lib/systemd/system/server_check.service" && \
sudo sed -i 's/<user>/'$user'/g' /etc/init.d/server-start && \
sudo sed -i 's/<pass>/'$pass'/g' /etc/init.d/server-start && \
sudo systemctl daemon-reload && \
sudo systemctl enable server_check.service && \
sudo systemctl start server_check.service && \
sudo systemctl status server_check.service