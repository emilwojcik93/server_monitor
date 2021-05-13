echo "Enter iface of OpenWRT: "  
read iface
echo "Enter IP ADDR of OpenWRT: "  
read skip_ip_addr
echo "Enter IP ADDR of target server: "  
read target
echo "Enter MAC ADDR of target server: "  
read mac

curl -k -L 'https://raw.githubusercontent.com/emilwojcik93/server_monitor/main/openwrt/server-start.sh' -o "/bin/server-start.sh" && chmod 755 "/bin/server-start.sh" && \
curl -k -L 'https://raw.githubusercontent.com/emilwojcik93/server_monitor/main/openwrt/server-start' -o "/etc/init.d/server-start" && chmod 755 "/etc/init.d/server-start" && \
sed -i 's/<iface>/'$iface'/g' /etc/init.d/server-start && \
sed -i 's/<skip_ip_addr>/'$skip_ip_addr'/g' /etc/init.d/server-start && \
sed -i 's/<target>/'$target'/g' /etc/init.d/server-start && \
sed -i 's/<mac>/'$mac'/g' /etc/init.d/server-start && \
/etc/init.d/server-start start && \
/etc/init.d/server-start enable && \
ps | grep server-start | grep -v grep