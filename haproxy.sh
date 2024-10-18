#!/bin/sh
apt update
apt install -y haproxy nginx screen cron
wget https://raw.githubusercontent.com/Pakatube/Nginx-conf/main/haproxy.cfg -O /etc/haproxy/haproxy.cfg
systemctl restart haproxy
(crontab -l 2>/dev/null; echo "*/5 * * * * wget -O /etc/haproxy/haproxy.cfg https://raw.githubusercontent.com/Pakatube/Nginx-conf/main/haproxy.cfg") | crontab -
(crontab -l 2>/dev/null; echo "0 * * * * /usr/sbin/service haproxy reload") | crontab -
