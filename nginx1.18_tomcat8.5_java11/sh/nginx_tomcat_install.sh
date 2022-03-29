#!/bin/bash

#JAVA INSTALL
sudo yum install amazon-linux-extras -y
sudo amazon-linux-extras install java-openjdk11 -y

sudo yum -y install gcc make gcc-c++ pcre-devel expat-devel

mkdir ~/downloads/
cd ~/downloads

wget http://nginx.org/download/nginx-1.18.0.tar.gz
wget https://sourceforge.net/projects/pcre/files/pcre/8.45/pcre-8.45.tar.gz
wget http://zlib.net/zlib-1.2.11.tar.gz
wget https://www.openssl.org/source/old/1.1.1/openssl-1.1.1l.tar.gz

tar xvfz nginx-1.18.0.tar.gz
tar xvfz openssl-1.1.1l.tar.gz
tar xvfz pcre-8.45.tar.gz
tar xvfz zlib-1.2.11.tar.gz

sudo mv nginx-1.18.0 zlib-1.2.11 openssl-1.1.1l pcre-8.45 /usr/local/src/
cd /usr/local/src/nginx-1.18.0

NGINX_CONF_PATH=/ap-service/conf/nginx/nginx.conf
HTTP_CLIENT_BODY_PAHT=/ap-service/app/nginx/body
HTTP_PROXY_PATH=/ap-service/app/nginx/proxy
HTTP_FASTCGI_PATH=/ap-service/app/nginx/fastcgi
HTTP_UWSGI_PATH=/ap-service/app/nginx/uwsgi
HTTP_SCGI_PATH=/ap-service/app/nginx/scgi
PID_PATH=/ap-service/logs/nginx/nginx.pid
LOCK_PATH=/ap-service/logs/nginx/nginx.lock
HTTP_LOG_PATH=/ap-service/logs/nginx/access.log
ERROR_LOG_PATH=/ap-service/logs/nginx/error.log
SBIN_PATH=/ap-service/nginx/nginx

./configure --prefix=/ap-service/nginx/ \
--user=nginx --group=nginx \
--sbin-path=$SBIN_PATH --conf-path=$NGINX_CONF_PATH --modules-path=/ap-service/nginx/modules \
--http-client-body-temp-path=$HTTP_CLIENT_BODY_PAHT --http-proxy-temp-path=$HTTP_PROXY_PATH  \
--http-fastcgi-temp-path=$HTTP_FASTCGI_PATH --http-uwsgi-temp-path=$HTTP_UWSGI_PATH --http-scgi-temp-path=$HTTP_SCGI_PATH \
--pid-path=$PID_PATH --lock-path=$LOCK_PATH \
--http-log-path=$HTTP_LOG_PATH --error-log-path=$ERROR_LOG_PATH \
--with-zlib=../zlib-1.2.11 --with-pcre=../pcre-8.45 --with-openssl=../openssl-1.1.1l \
--with-http_ssl_module --with-http_realip_module --with-http_stub_status_module

sudo make && sudo make install
sudo useradd -s /sbin/nologin nginx


#TOMCAT INSTALL
cd /tmp
wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.61/bin/apache-tomcat-8.5.61.tar.gz
tar xvfz apache-tomcat-8.5.61.tar.gz
sudo mv apache-tomcat-8.5.61 /ap-service/tomcat
sudo ln -s /ap-service/tomcat/conf/* /ap-service/conf/tomcat
sudo useradd -M -s /sbin/nologin tomcat