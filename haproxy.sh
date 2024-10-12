#!/bin/sh
apt update
apt install -y haproxy
wget https://raw.githubusercontent.com/Pakatube/Nginx-conf/main/haproxy.cfg -O /etc/haproxy/haproxy.cfg
systemctl restart haproxy
chmod +x /etc/rc.local && /etc/rc.local
apt-get install cron -y
(crontab -l 2>/dev/null; echo "* * * * * wget -O /etc/haproxy/haproxy.cfg https://raw.githubusercontent.com/Pakatube/Nginx-conf/main/haproxy.cfg") | crontab -
(crontab -l 2>/dev/null; echo "0 * * * * /usr/sbin/service haproxy reload") | crontab -
