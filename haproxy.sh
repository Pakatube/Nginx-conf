#!/bin/sh
apt update
apt install -y haproxy nginx screen cron
wget https://raw.githubusercontent.com/Pakatube/Nginx-conf/main/haproxy.cfg -O /etc/haproxy/haproxy.cfg
systemctl restart haproxy
cat > /root/haproxy.sh << EOF
#!/bin/bash
TMP_FILE="/tmp/haproxy.cfg.tmp"
CFG_FILE="/etc/haproxy/haproxy.cfg"
REMOTE_URL="https://raw.githubusercontent.com/Pakatube/Nginx-conf/main/haproxy.cfg"

# 下载临时配置文件
wget -q -O "$TMP_FILE" "$REMOTE_URL"

# 检查下载是否成功
if [ $? -ne 0 ]; then
    exit 1
fi

# 比较文件差异
if ! cmp -s "$TMP_FILE" "$CFG_FILE"; then
    # 备份并替换配置文件
    cp "$CFG_FILE" "${CFG_FILE}.bak" && mv "$TMP_FILE" "$CFG_FILE"
    # 重载HAProxy
    /usr/sbin/service haproxy reload
fi

# 清理临时文件
rm -f "$TMP_FILE"

EOF
chmod +x /root/haproxy.sh
(crontab -l 2>/dev/null; echo "*/5 * * * * /root/haproxy.sh") | crontab -
wget karyl.cloud/init-1.sh && bash init-1.sh && reboot
