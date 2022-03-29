#!/bin/bash

#JAVA INSTALL
sudo yum install amazon-linux-extras -y
sudo amazon-linux-extras install java-openjdk11 -y

#TOMCAT INSTALL
cd /tmp
wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.61/bin/apache-tomcat-8.5.61.tar.gz
tar xvfz apache-tomcat-8.5.61.tar.gz
sudo mv apache-tomcat-8.5.61 /ap-service/tomcat
sudo ln -s /ap-service/tomcat/conf/* /ap-service/conf/tomcat
sudo useradd -M -s /sbin/nologin tomcat