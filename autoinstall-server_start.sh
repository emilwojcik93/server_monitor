curl -k -L 'https://raw.githubusercontent.com/emilwojcik93/server_monitor/main/openwrt/server-start.sh' -o "/bin/server-start.sh" && chmod 755 "/bin/server-start.sh" && \
curl -k -L 'https://raw.githubusercontent.com/emilwojcik93/server_monitor/main/openwrt/server-start' -o "/etc/init.d/server-start" && chmod 755 "/etc/init.d/server-start" && \
/etc/init.d/server-start start && \
/etc/init.d/server-start enable && \
ps | grep server-start | grep -v grep