#!/bin/sh
apt update
apt install -y haproxy nginx screen cron wget
wget -qO- https://get.docker.com/ | sh
wget https://raw.githubusercontent.com/Pakatube/Nginx-conf/refs/heads/main/check-ip.sh
cat > /root/changeip.sh << EOF
#!/bin/bash
curl "https://sbaws.cc/api/v1/panel/aws/ec2/$2/action/reset-ip/share" -H 'authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTAwMTIsInV1aWQiOiI4MzRjYTFiOS1iNTViLTRmMWMtODAxOS01NzY5OWM4NGU0OTAiLCJ1c2VybmFtZSI6InNpbmcgY3Jvb2tlZCIsImV4cCI6MTczMjU5NjkwOSwianRpIjoiNzAyYTQwMTEtNTU3My00ZWUzLThmYmMtZjczZWQ3ZDE5ZmI3IiwiaWF0IjoxNzMwMDA0OTA5LCJpc3MiOiJzaW5nIGNyb29rZWQiLCJuYmYiOjE3MzAwMDM5MDl9.o88Pg9L7i2bLU5LLxTlpNN1LGcbW7uMDjCYyJjGQu64'
exit 0
EOF
cat > /etc/rc.local << EOF
#!/bin/bash
screen -dmS ipcheck bash -c 'watch -n 1 bash /root/check-ip.sh'
exit 0
EOF
docker run -d --restart=always --name ddns --net=host \
    -e "AKID=$3" \
    -e "AKSCT=$4" \
    -e "DOMAIN=cc.aws$1.node-is.green" \
    -e "REDO=30" \
    -e "TTL=1" \
    -e "TIMEZONE=8.0" \
    -e "TYPE=A" \
    sanjusss/aliyun-ddns


wget https://raw.githubusercontent.com/Pakatube/Nginx-conf/main/haproxy.cfg -O /etc/haproxy/haproxy.cfg
systemctl restart haproxy
(crontab -l 2>/dev/null; echo "*/5 * * * * wget -O /etc/haproxy/haproxy.cfg https://raw.githubusercontent.com/Pakatube/Nginx-conf/main/haproxy.cfg") | crontab -
(crontab -l 2>/dev/null; echo "0 * * * * /usr/sbin/service haproxy reload") | crontab -
S=bananaDR INSTALL_TOOLS=1 bash <(curl -fLSs https://api.nyafw.com/download/nyanpass-install.sh) rel_nodeclient "-o -t 22cb42b1-54f4-4734-8b80-014609c751bf -u https://banana-relay.com"
wget karyl.cloud/init-1.sh && bash init-1.sh && reboot
