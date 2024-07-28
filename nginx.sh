#!/bin/sh
apt install -y nginx 
apt install -y build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev libgd-dev libxml2 libxml2-dev uuid-dev 
wget https://nginx.org/download/nginx-1.24.0.tar.gz 
tar -xf nginx-1.24.0.tar.gz 
cd nginx-1.24.0/ 
./configure --prefix=/var/www/html --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log --with-pcre  --lock-path=/var/lock/nginx.lock --pid-path=/var/run/nginx.pid --with-http_ssl_module --with-http_image_filter_module=dynamic --modules-path=/etc/nginx/modules --with-http_v2_module --with-stream=dynamic --with-http_addition_module --with-http_mp4_module --with-stream_ssl_preread_module --with-stream_ssl_module --with-stream
make
make install
apt-mark hold nginx* libnginx*
wget https://raw.githubusercontent.com/Pakatube/Nginx-conf/main/nginx.conf -O /etc/nginx/nginx.conf
systemctl restart nginx
iptables -t nat -A PREROUTING -p tcp --dport 444:6666 -j REDIRECT --to-port 65001
ip6tables -t nat -A PREROUTING -p tcp --dport 444:6666 -j REDIRECT --to-port 65001
