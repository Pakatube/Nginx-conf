#!/bin/sh
apt install -y nginx
apt install -y build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev libgd-dev libxml2 libxml2-dev uuid-dev 
wget https://tengine.taobao.org/download/tengine-3.1.0.tar.gz
tar -xf tengine-3.1.0.tar.gz
cd tengine-3.1.0/ 
./configure --prefix=/var/www/html --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log --with-pcre  --lock-path=/var/lock/nginx.lock --pid-path=/var/run/nginx.pid --with-http_ssl_module --with-http_image_filter_module=dynamic --modules-path=/etc/nginx/modules --with-http_v2_module --with-stream=dynamic --with-http_addition_module --with-http_mp4_module --with-stream_ssl_preread_module --with-stream_ssl_module --with-stream --with-stream_sni --add-module=modules/ngx_http_upstream_dynamic_module
make
make install
apt-mark hold nginx* libnginx*
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
