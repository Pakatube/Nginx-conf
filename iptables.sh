#!/bin/sh
cat > /etc/rc.local << EOF
#!/bin/bash
iptables -F -t nat
iptables -t nat -A PREROUTING -p tcp --dport 40000:50000 -j DNAT --to-destination 45.9.2.253:65001
iptables -t nat -A POSTROUTING -p tcp -d 45.9.2.253 --dport 65001 -j MASQUERADE
exit 0
EOF
chmod +x /etc/rc.local && /etc/rc.local
