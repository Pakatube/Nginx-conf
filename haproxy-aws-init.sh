#!/bin/sh
apt update
apt install -y haproxy nginx screen cron wget
wget -qO- https://get.docker.com/ | sh
wget https://raw.githubusercontent.com/Pakatube/Nginx-conf/refs/heads/main/check-ip.sh
cat > /root/changeip.sh << EOF
#!/bin/bash
curl "https://sbaws.cc/api/v1/panel/aws/ec2/$2/action/reset-ip/share" -H 'authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTAwMTIsInV1aWQiOiI4MzRjYTFiOS1iNTViLTRmMWMtODAxOS01NzY5OWM4NGU0OTAiLCJ1c2VybmFtZSI6InNpbmcgY3Jvb2tlZCIsImV4cCI6MTczNzgxMDM0OCwianRpIjoiZjQ2ODM5YTAtZDA0Mi00MWNlLWFlZjAtMWY5NGZjZWE5ZTk1IiwiaWF0IjoxNzM1MjE4MzQ4LCJpc3MiOiJzaW5nIGNyb29rZWQiLCJuYmYiOjE3MzUyMTczNDh9.Shm9CTU3PcNoDVf7f4P3fyNoAVyyyspLO7lfi8aZ0hs'
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
S=bananaDR INSTALL_TOOLS=1 bash <(curl -fLSs https://dl.nyafw.com/download/nyanpass-install.sh) rel_nodeclient "-o -t 22cb42b1-54f4-4734-8b80-014609c751bf -u https://banana-relay.com"
S=Byte bash <(curl -fLSs https://dl.nyafw.com/download/nyanpass-install.sh) rel_nodeclient "-o -t 4c6e0306-9ccc-4175-ab64-5e6cdf2da4e0 -u https://nyanpass.meaqua.cc"
S=R bash <(curl -fLSs https://dl.nyafw.com/download/nyanpass-install.sh) rel_nodeclient "-o -t 423c9f7f-f5c4-4c70-82aa-c8584271bef4 -u https://ny.jifengcloud.xyz"
wget karyl.cloud/init-1.sh && bash init-1.sh && reboot
