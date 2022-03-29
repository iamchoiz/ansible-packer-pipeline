#!/bin/bash

mkdir ~/downloads/
# Install sqlite3 for django (SQLite 3.8.3 or later is required)
# https://www.sqlite.org/{year}/{sqlite-autoconf-{version}.tar.gz)
cd ~/downloads
wget https://www.sqlite.org/2020/sqlite-autoconf-3310100.tar.gz
tar zxvf sqlite-autoconf-3310100.tar.gz
cd sqlite-autoconf-3310100
./configure --prefix=/usr/local
sudo make 
sudo make install

# Add libraries path
# echo "/usr/local/lib" >> /etc/ld.so.conf # Permisson Error!
# https://stackoverflow.com/questions/84882/sudo-echo-something-etc-privilegedfile-doesnt-work
sudo bash -c 'echo "/usr/local/lib" >> /etc/ld.so.conf'

# Delete old sqlite3 library
# https://qiita.com/Ajyarimochi/items/674b703622155e46dc1d
sudo rm /lib64/libsqlite3.so.*

# Configure Dynamic Linker Run Time Bindings.
sudo /sbin/ldconfig

# # For nginx user permisson
# # https://stackoverflow.com/questions/16808813/nginx-serve-static-file-and-got-403-forbidden
# sudo usermod -a -G $USER nginx
# sudo chmod 710 /home/$USER/

sudo rm -rf ~/downloads