#!/bin/bash

#JAVA INSTALL
sudo yum install java-1.8.0-openjdk-devel.x86_64 -y

#TOMCAT INSTALL
cd /tmp
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.41/bin/apache-tomcat-9.0.41.tar.gz
tar xvfz apache-tomcat-9.0.41.tar.gz
sudo mv apache-tomcat-9.0.41 /ap-service/tomcat
sudo ln -s /ap-service/tomcat/conf/* /ap-service/conf/tomcat
sudo useradd -M -s /sbin/nologin tomcat