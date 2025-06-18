#!/bin/sh
cat > /etc/rc.local << EOF
#!/bin/bash
iptables -F -t nat
iptables -t nat -A PREROUTING -p udp --dport 61000:61665 -j REDIRECT --to-port 61666
exit 0
EOF
chmod +x /etc/rc.local && /etc/rc.local
