#!/bin/bash

#TOMCAT INSTALL
cd /tmp
wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.61/bin/apache-tomcat-8.5.61.tar.gz
tar xvfz apache-tomcat-8.5.61.tar.gz
sudo mv apache-tomcat-8.5.61 /ap-service/tomcat
sudo ln -s /ap-service/tomcat/conf/* /ap-service/conf/tomcat
sudo useradd -M -s /sbin/nologin tomcat

echo error page | sudo tee -a /ap-service/app/tomcat/error.html

echo -e "[UNIT]
Description=tomcat8.5
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

sudo rm -rf ~/downloads /tmp/tomcat8.5_install.sh