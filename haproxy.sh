#!/bin/sh
apt update
apt install -y haproxy
wget https://raw.githubusercontent.com/Pakatube/Nginx-conf/main/haproxy.cfg -O /etc/haproxy/haproxy.cfg
systemctl restart haproxy
cat > /etc/rc.local << EOF
#!/bin/bash
iptables -F -t nat
ip6tables -F -t nat
iptables -t nat -A PREROUTING -p tcp --dport 40000:50000 -j REDIRECT --to-port 65001
ip6tables -t nat -A PREROUTING -p tcp --dport 40000:50000 -j REDIRECT --to-port 65001
exit 0
EOF
chmod +x /etc/rc.local && /etc/rc.local
apt-get install cron -y
cat > /usr/local/bin/update-haproxy.sh << EOF
#!/bin/bash
wget -O /etc/haproxy/haproxy.cfg https://raw.githubusercontent.com/Pakatube/Nginx-conf/main/haproxy.cfg
service haproxy reload
EOF
chmod +x /usr/local/bin/update-haproxy.sh
(crontab -l; echo "*/10 * * * * /usr/local/bin/update-haproxy.sh") | crontab -
