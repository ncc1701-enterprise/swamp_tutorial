#!/bin/bash
# This script will download, compile and setup nginx with rtmp to be used for swamp cinema
# for more information see swampservers.net or github.com/ncc1701-enterprise/swamp_tutorial/wiki/How-to-set-up-your-own-livestream-for-Swamp-Cinema

# getting fresh apt sources and installing all depencies
apt-get update
apt-get install nano htop unzip gcc make build-essential libpcre3 libpcre3-dev libc6 libssl-dev zlib1g zlib1g-dev lsb-base openssl -y

# downloading nginx source and rtmp module
mkdir /tmp/nginx_rtmp_tmp
wget -O /tmp/nginx_rtmp_tmp/nginx.tar http://nginx.org/download/nginx-1.15.2.tar.gz
wget -O /tmp/nginx_rtmp_tmp/master.zip https://github.com/arut/nginx-rtmp-module/archive/master.zip

# extracting the downloads to current directory and deleting the temp files
tar xfv /tmp/nginx_rtmp_tmp/nginx.tar
unzip /tmp/nginx_rtmp_tmp/master.zip
rm -R /tmp/nginx_rtmp_tmp

# compile nginx source with rtmp module and install afterward
cd nginx-1.15.2
./configure --with-http_ssl_module --add-module=../nginx-rtmp-module-master
make -j 2
make install

# configure nginx to listen for streams on port 1935
echo "rtmp {" >> /usr/local/nginx/conf/nginx.conf
echo "        server {" >> /usr/local/nginx/conf/nginx.conf
echo "                listen 1935;" >> /usr/local/nginx/conf/nginx.conf
echo "                chunk_size 4096;" >> /usr/local/nginx/conf/nginx.conf
echo "                application live {" >> /usr/local/nginx/conf/nginx.conf
echo "                        live on;" >> /usr/local/nginx/conf/nginx.conf
echo "                        record off;" >> /usr/local/nginx/conf/nginx.conf
echo "                }" >> /usr/local/nginx/conf/nginx.conf
echo "        }" >> /usr/local/nginx/conf/nginx.conf
echo "}" >> /usr/local/nginx/conf/nginx.conf

# starting nginx
/usr/local/nginx/sbin/nginx

# output the data and quit
echo "##### WE ARE FINISHED #####"
echo ""
echo "You can now enter rtmp://<your servers IP>:1935/live into Open Broadcaster"
echo ""
echo "You can use whatever key you want, even multiple users can use a single server with different keys"
echo ""
echo "Enter rtmp://<your servers IP>:1935/live/<key> into the chat while in a cinema to add your stream to the queue"
echo ""
echo "###########################"
