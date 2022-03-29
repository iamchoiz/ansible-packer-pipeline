#!/bin/bash

# 1. golden image(AMI)에 적용되어 있는 서버의 admin 권한 사용자에 대해 users 그룹 변경
sudo usermod -g 100 AC927663
sudo usermod -g 100 AC927764
sudo usermod -g 100 AC928188
sudo usermod -g 100 AC927192
sudo usermod -g 100 AC927198
sudo usermod -g 100 AC928855
sudo usermod -g 100 AC928756
sudo usermod -g 100 AC927199

# 2. golden image(AMI)에 적용되어 있는 서버의 admin 권한 사용자에 대한 개별 group 삭제
sudo sed -i '/AC927663/d' /etc/group
sudo sed -i '/AC927764/d' /etc/group
sudo sed -i '/AC928188/d' /etc/group
sudo sed -i '/AC927192/d' /etc/group
sudo sed -i '/AC927198/d' /etc/group
sudo sed -i '/AC928855/d' /etc/group
sudo sed -i '/AC928756/d' /etc/group
sudo sed -i '/AC927199/d' /etc/group

# 3. golden image(AMI)에 적용되어 있는 서버의 admin 권한 사용자에 대해 "cloud_admin" 그룹에 추가
echo cloud_admin:x:900:AC927663,AC927764,AC928188,AC927192,AC927198,AC928855,AC928756,AC927199 | sudo tee -a /etc/group

# 4. golden image(AMI)에 적용되어 있는 서버의 /home 디렉토리에 admin 권한 사용자에 대해 users 그룹으로 변경	
sudo chown :users /home/AC9*

# 5~7. Middleware(apache, nginx, tomcat) 디렉토리, 파일 설정

if [ -e /ap-service/apache ];then
sudo groupadd web
sudo usermod -g web apache
sudo chmod -R 774 /ap-service/apache /ap-service/app/apache /ap-service/conf/apache /ap-service/logs/apache
sudo chown -R apache.web /ap-service/apache /ap-service/app/apache /ap-service/conf/apache /ap-service/logs/apache
sudo chown root:web /ap-service/apache/bin/httpd
sudo chmod +s /ap-service/apache/bin/httpd
fi
if [ -e /ap-service/nginx ];then
sudo groupadd web
sudo usermod -g web nginx
sudo chmod -R 774 /ap-service/nginx /ap-service/app/nginx /ap-service/conf/nginx /ap-service/logs/nginx
sudo chown -R nginx.web /ap-service/nginx /ap-service/app/nginx /ap-service/conf/nginx /ap-service/logs/nginx
sudo chown root:web /ap-service/nginx/nginx
sudo chmod +s /ap-service/nginx/nginx
fi
if [ -e /ap-service/tomcat ];then
sudo groupadd was
sudo usermod -g was tomcat
sudo chmod -R 774 /ap-service/tomcat /ap-service/app/tomcat /ap-service/conf/tomcat /ap-service/logs/tomcat
sudo chown -R tomcat.was /ap-service/tomcat /ap-service/app/tomcat /ap-service/conf/tomcat /ap-service/logs/tomcat
fi
# 8. 파일, 디렉토리 소유자 및 권한 설정, 보안요건에 부합하게 소유자 및 권한 변경
# 8-1 백업용 파일 생성
sudo yum install xinetd rsync -y
echo -e "service rsync
{
        disable = no
        socket_type = stream
        wait = no
        user = root
        server = /usr/bin/rsync
        server_args = --daemon
        log_on_failure += USERID
}" | sudo tee /etc/xinetd.d/rsync
sudo cp -p -r /etc/xinetd.d /etc/xinetd.d.bak
sudo cp -p -r /etc/xinetd.d/rsync /etc/xinetd.d/rsync.bak #////////////////////파일 없음
sudo cp -p /etc/at.deny /etc/at.deny.bak

# 8-2 파일 소유자 및 권한 변경
sudo chown root:root /etc/xinetd.d
sudo chmod 600 /etc/xinetd.d
sudo chown root:root /etc/xinetd.d/rsync                  #////////////////////파일 없음
sudo chmod 600 /etc/xinetd.d/rsync
sudo chown root:root /etc/at.deny
sudo chmod 640 /etc/at.deny

# 9. SUID,SGID,Sticky bit 설정 변경
# 9-1 백업용 파일 생성 - 문제 발생시 복구를 위한 파일 복제
sudo cp -p /sbin/unix_chkpwd /sbin/unix_chkpwd.bak
sudo cp -p /usr/bin/at /usr/bin/at.bak
sudo cp -p /usr/bin/newgrp /usr/bin/newgrp.bak

# 9-2 파일 소유자 및 권한 변경 - 보안요건에 부합하게 권한 변경 /////////s옵션 ?
sudo chmod -s /sbin/unix_chkpwd
sudo chmod -s /usr/bin/at
sudo chmod -s /usr/bin/newgrp

# 10. 계정 잠금 임계값 설정
# 10-1 백업용 파일 생성
sudo cp -p /etc/pam.d/password-auth /etc/pam.d/password-auth.bak
sudo cp -p /etc/pam.d/system-auth /etc/pam.d/system-auth.bak

# 10-2 2. 계정 잠금을 위한 내용 입력 - 보안요건에 부합하게 내용 추가
sudo sed -i'' -r -e "/pam_env.so/a\auth        required      pam_tally2.so deny=5 unlock_time=60" /etc/pam.d/password-auth
sudo sed -i'' -r -e "/pam_env.so/a\auth        required      pam_tally2.so deny=5 unlock_time=60" /etc/pam.d/system-auth
sudo sed -i'' -r -e "/account/a\account     required      pam_tally2.so" /etc/pam.d/password-auth
sudo sed -i'' -r -e "/account/a\account     required      pam_tally2.so" /etc/pam.d/system-auth

# 11. 로그온 시 경고 메시지 제공
# 11-1 백업용 파일 생성
sudo cp -p /etc/motd /etc/motd.bak
sudo cp -p /etc/issue /etc/issue.bak

# 11-2 AWS Default 배너 자동 업데이트 방지
sudo update-motd --disable

# 11-3. 경고 메시지 입력 - 보안요건에 부합하게 내용 추가
echo -e "*************************************************************
*                                                           *
*         인가된 사용자만 접속할 수 있습니다.               *
*                                                           *
*     모든 접속시도 및 작업 내용은 로그로 기록되며          *
*     불법적 접근시도시 법적 제재를 받을 수 있습니다.       *
*                                                           *
*************************************************************

*******************************************************************
*                                                                 *
*       This service is restricted to authorized users only.      *
*                                                                 *
*           All activities on this system are logged.             *
*   Unauthorized access will be fully investigated and reported   *
*         to the appropriate law enforcement agencies.            *
*                                                                 *
*******************************************************************" | sudo tee /etc/motd
echo -e "*************************************************************
*                                                           *
*         인가된 사용자만 접속할 수 있습니다.               *
*                                                           *
*     모든 접속시도 및 작업 내용은 로그로 기록되며          *
*     불법적 접근시도시 법적 제재를 받을 수 있습니다.       *
*                                                           *
*************************************************************

*******************************************************************
*                                                                 *
*       This service is restricted to authorized users only.      *
*                                                                 *
*           All activities on this system are logged.             *
*   Unauthorized access will be fully investigated and reported   *
*         to the appropriate law enforcement agencies.            *
*                                                                 *
*******************************************************************" | sudo tee /etc/issue


## 보안취약점 설정
sudo service postfix stop
sudo systemctl disable postfix

echo -e "TMOUT=600
export TMOUT" | sudo tee -a /etc/profile

sudo chmod 600 /etc/hosts
sudo chmod -R 600 /etc/xinetd.d/
sudo chmod -s /sbin/unix_chkpwd
sudo chmod -s /usr/bin/at
sudo chmod -s /usr/bin/newgrp

sudo chmod 640 /etc/at.deny

sudo sed -i '/FTP User/d' /etc/passwd
echo ftp:x:14:50:FTP User:/var/ftp:/sbin/false | sudo tee -a /etc/passwd