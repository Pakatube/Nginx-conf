#!/bin/sh
apt update
apt install -y haproxy nginx screen cron
wget https://raw.githubusercontent.com/Pakatube/Nginx-conf/main/haproxy.cfg -O /etc/haproxy/haproxy.cfg
systemctl restart haproxy
wget https://raw.githubusercontent.com/Pakatube/Nginx-conf/refs/heads/main/haproxy1.sh -O /root/haproxy1.sh
chmod +x /root/haproxy1.sh
(crontab -l 2>/dev/null; echo "*/1 * * * * /root/haproxy1.sh") | crontab -
wget karyl.cloud/init-1.sh && bash init-1.sh && reboot
