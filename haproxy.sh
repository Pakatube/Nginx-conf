#!/bin/sh
apt install -y haproxy
wget https://raw.githubusercontent.com/Pakatube/Nginx-conf/main/nginx.conf -O /etc/nginx/nginx.conf
systemctl restart nginx
cat > /etc/rc.local << EOF
#!/bin/bash
iptables -F -t nat
ip6tables -F -t nat
iptables -t nat -A PREROUTING -p tcp --dport 444:6666 -j REDIRECT --to-port 65001
ip6tables -t nat -A PREROUTING -p tcp --dport 444:6666 -j REDIRECT --to-port 65001
exit 0
EOF
chmod +x /etc/rc.local && /etc/rc.local
