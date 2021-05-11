# Script only works if sudo caches the password for a few minutes
sudo true && \
sudo curl -k -L 'https://raw.githubusercontent.com/emilwojcik93/server_monitor/main/server_check.py' -o "/opt/server_check.py" && sudo chmod 755 "/opt/server_check.py" && \
sudo curl -k -L 'https://raw.githubusercontent.com/emilwojcik93/server_monitor/main/server_check.service' -o "/lib/systemd/system/server_check.service" && \
echo -e "Please change \e[91m<user> <pass>\e[0m in \e[91mExecStart\e[0m (line 8)\nThen press \e[91mCTRL+x\e[0m, then \e[91mEnter\e[0m" && \
sleep 5 && \
sudo nano /lib/systemd/system/server_check.service && \
sudo systemctl daemon-reload && \
sudo systemctl enable server_check.service && \
sudo systemctl start server_check.service && \
sudo systemctl status server_check.service