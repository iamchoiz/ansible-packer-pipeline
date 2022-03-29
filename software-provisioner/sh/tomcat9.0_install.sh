#!/bin/bash

#TOMCAT INSTALL
cd /tmp
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.41/bin/apache-tomcat-9.0.41.tar.gz
tar xvfz apache-tomcat-9.0.41.tar.gz
sudo mv apache-tomcat-9.0.41 /ap-service/tomcat
sudo ln -s /ap-service/tomcat/conf/* /ap-service/conf/tomcat
sudo useradd -M -s /sbin/nologin tomcat

echo -e "[UNIT]
Description=tomcat9.0
After=syslog.target network.target

[Service]
Type=forking

ExecStart=/ap-service/tomcat/bin/startup.sh
ExecStop=/ap-service/tomcat/bin/shutdown.sh

User=tomcat
Group=was

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/tomcat.service

sudo systemctl daemon-reload
sudo systemctl enable tomcat

sudo rm -rf ~/downloads /tmp/tomcat9.0_install.sh