#!/bin/bash

sudo yum -y install gcc make gcc-c++ pcre-devel expat-devel

mkdir ~/downloads/
cd ~/downloads

wget https://archive.apache.org/dist/httpd/httpd-2.4.46.tar.gz
     

wget http://mirror.apache-kr.org/apr/apr-1.7.0.tar.gz

wget http://apache.mirror.cdnetworks.com/apr/apr-util-1.6.1.tar.gz

wget https://sourceforge.net/projects/pcre/files/pcre2/10.37/pcre2-10.37.tar.gz


tar xvfz httpd-2.4.46.tar.gz
tar xvfz apr-1.7.0.tar.gz
tar xvfz apr-util-1.6.1.tar.gz
tar xvfz  pcre2-10.37.tar.gz

sudo mv apr-1.7.0 apr-util-1.6.1 httpd-2.4.46 pcre2-10.37 /usr/local/src

cd /usr/local/src/apr-1.7.0
./configure --prefix=/usr/local/src/apr-1.7.0
sudo make && sudo make install

cd /usr/local/src/apr-util-1.6.1
./configure --prefix=/usr/local/src/apr-util-1.6.1 --with-apr=/usr/local/src/apr-1.7.0
sudo make && sudo make install

cd /usr/local/src/pcre2-10.37
./configure --prefix=/usr/local/src/apr-util-1.6.1 --with-apr=/usr/local/src/apr-1.7.0
sudo make && sudo make install

cd /usr/local/src/httpd-2.4.46
APACHE_HOME=/ap-service/apache
SYSCON_DIR=/ap-service/conf/apache

sudo ./configure --prefix=$APACHE_HOME \
--sysconfdir=$SYSCON_DIR \
--enable-modules=most --enable-mods-shared=all --enable-so \
--with-apr=/usr/local/src/apr-1.7.0 --with-apr-util=/usr/local/src/apr-util-1.6.1
sudo make && sudo make install

sudo useradd -M -s /sbin/nologin apache

echo error page | sudo tee -a /ap-service/app/apache/error.html

echo -e "[Unit]
Description=The Apache HTTP Server

[Service]
Type=forking
EnvironmentFile=$APACHE_HOME/bin/envvars
PIDFile=$APACHE_HOME/logs/httpd.pid
ExecStart=$APACHE_HOME/bin/apachectl start
ExecReload=$APACHE_HOME/bin/apachectl graceful
ExecStop=$APACHE_HOME/bin/apachectl stop
KillSignal=SIGCONT
PrivateTmp=true
User=apache
Group=web

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/httpd.service

sudo systemctl daemon-reload
sudo systemctl enable httpd
# echo "# chkconfig: 2345 90 90" | sudo tee -a /ap-service/apache/bin/apachectl
# sudo cp /ap-service/apache/bin/apachectl /etc/init.d/httpd
# sudo chkconfig --add httpd
# sudo systemctl enable httpd

sudo rm -rf ~/downloads /tmp/apache2.4_install.sh