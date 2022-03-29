#!/bin/bash

# 1. golden image(AMI)에 적용되어 있는 서버의 admin 권한 사용자에 대해 users 그룹 변경 (group id를 100)
if [ "$(cat passwd |grep AC | awk -F : '{total+=$4} END {print total%100}')" == 0 ]
then
    echo -e "\033[32m"Succeeded"\033[0m - 01.Admin 계정 GID (100) Check"
else
    echo -e "\033[31m"Failed"\033[0m - 01.Admin 계정 GID (100) Check"
    exit 9
fi

# 2. golden image(AMI)에 적용되어 있는 서버의 admin 권한 사용자에 대한 개별 group 삭제
if [ "$(cat /etc/group | grep AC92 -wc)" == 0 ]
then
    echo -e "\033[32m"Succeeded"\033[0m - 02.Admin 사용자 개별 Group 확인"
else
    echo -e "\033[31m"Failed"\033[0m - 02.Admin 사용자 개별 Group 확인"
    exit 9
fi

# 3. golden image(AMI)에 적용되어 있는 서버의 admin 권한 사용자에 대해 "cloud_admin" 그룹에 추가
if [ "$(cat /etc/group | grep cloud_admin:x:900:AC927663,AC927764,AC928188,AC927192,AC927198,AC928855,AC928756,AC927199 -wc)" == 1 ]
then
    echo -e "\033[32m"Succeeded"\033[0m - 03.cloud_admin 사용자 Group 확인"
else
    echo -e "\033[31m"Failed"\033[0m - 03.cloud_admin 사용자 Group 확인"
    exit 9
fi

# 4. # home 하위 dir 그룹 체크 (users)
arr=(`ls -l /home | grep AC92 | awk '{print $4}'`)
for var in "${arr[@]}"
do
    if [ $var == "users" ]
    then
        echo -e "\033[32m"Succeeded"\033[0m - 04.Admin 계정 하위 Group : user"
    else
        echo -e "\033[31m"Failed"\033[0m - 04.Admin 계정 하위 Group : user"
        exit 9
    fi
done

# 5. # /ap-service 미들웨어 dir 권한 774
if [ -e /ap-service/apache ];then
    if [ "$(ls -l /ap-service | grep apache | awk '{print $1}')" == "drwxrwxr--" ]
    then
        echo -e "\033[32m"Succeeded Apache HOME"\033[0m - 05.Middleware Home DIR 권한 확인"
    else
        echo -e "\033[31m"Failed Apache HOME"\033[0m - 05.Middleware Home DIR 권한 확인"
        exit 9
    fi
fi
if [ -e /ap-service/nginx ];then
    if [ "$(ls -l /ap-service | grep nginx | awk '{print $1}')" == "drwxrwxr--" ]
    then
        echo -e "\033[32m"Succeeded Nginx HOME"\033[0m - 05.Middleware Home DIR 권한 확인"
    else
        echo -e "\033[31m"Failed Nginx HOME"\033[0m - 05.Middleware Home DIR 권한 확인"
        exit 9
    fi
fi
if [ -e /ap-service/tomcat ];then
    if [ "$(ls -l /ap-service | grep tomcat | awk '{print $1}')" == "drwxrwxr--" ]
    then
        echo -e "\033[32m"Succeeded Tomcat HOME"\033[0m - 05.Middleware Home DIR 권한 확인"
    else
        echo -e "\033[31m"Failed Tomcat HOME"\033[0m - 05.Middleware Home DIR 권한 확인"
        exit 9
    fi
fi

# 6. /ap-service/app 미들웨어 dir 권한 774
if [ -e /ap-service/app/apache ];then
    if [ "$(ls -l /ap-service/app | grep apache | awk '{print $1}')" == "drwxrwxr--" ]
    then
        echo -e "\033[32m"Succeeded Apache APP HOME"\033[0m - 06.Middleware APP DIR 권한 확인"
    else
        echo -e "\033[31m"Failed Apache APP HOME"\033[0m - 06.Middleware APP DIR 권한 확인"
        exit 9
    fi
fi
if [ -e /ap-service/app/nginx ];then
    if [ "$(ls -l /ap-service/app | grep nginx | awk '{print $1}')" == "drwxrwxr--" ]
    then
        echo -e "\033[32m"Succeeded Nginx APP HOME"\033[0m - 06.Middleware APP DIR 권한 확인"
    else
        echo -e "\033[31m"Failed Nginx APP HOME"\033[0m - 06.Middleware APP DIR 권한 확인"
        exit 9
    fi
fi
if [ -e /ap-service/app/nginx ];then
    if [ "$(ls -l /ap-service/app | grep nginx | awk '{print $1}')" == "drwxrwxr--" ]
    then
        echo -e "\033[32m"Succeeded Nginx APP HOME"\033[0m - 06.Middleware APP DIR 권한 확인"
    else
        echo -e "\033[31m"Failed Nginx APP HOME"\033[0m - 06.Middleware APP DIR 권한 확인"
        exit 9
    fi
fi
if [ -e /ap-service/app/tomcat ];then
    if [ "$(ls -l /ap-service/app | grep tomcat | awk '{print $1}')" == "drwxrwxr--" ]
    then
        echo -e "\033[32m"Succeeded Tomcat APP HOME"\033[0m - 06.Middleware APP DIR 권한 확인"
    else
        echo -e "\033[31m"Failed Tomcat APP HOME"\033[0m - 06.Middleware APP DIR 권한 확인"
        exit 9
    fi
fi

# 07. xinetd.d.bak 존재여부 확인
if [ -e /etc/xinetd.d.bak ];
then
    echo -e "\033[32m"Succeeded"\033[0m - 07.xinetd.d 백업"
else
    echo -e "\033[31m"Failed"\033[0m - 07.xinetd.d 백업"
    exit 9
fi

# 08. rsync.bak 존재여부 확인
if [ "$(sudo ls /etc/xinetd.d | grep rsync.bak -wc)" == 1 ]
then
    echo -e "\033[32m"Succeeded"\033[0m - 08.rsync.d 백업"
else
    echo -e "\033[31m"Failed"\033[0m - 08.rsync.d 백업"
    exit 9
fi

# 09. at.deny.bak 존재여부 확인
if [ -e /etc/at.deny.bak ];
then
    echo -e "\033[32m"Succeeded"\033[0m - 09.at.deny 백업"
else
    echo -e "\033[31m"Failed"\033[0m - 09.at.deny 백업"
    exit 9
fi


# 10. /etc/xinetd.d 사용자 및 그룹 확인 (root), 600 권한 확인
arr=(`ls -l /etc | grep xinetd.d | grep -v bak | awk '{print $1,$3,$4}'`)
if [ "${arr[0]}" == "drw-------" ] && [ "${arr[1]}" == "root" ] && [ "${arr[2]}" == "root" ]
then
    echo -e "\033[32m"Succeeded"\033[0m - 10./etc/xinetd.d 권한 및 사용자, 그룹 확인"
else
    echo -e "\033[31m"Failed"\033[0m - 10./etc/xinetd.d 권한 및 사용자, 그룹 확인"
    exit 9
fi

# 11. /etc/xinetd.d/rsync 사용자 및 그룹 확인 (root), 600 권한 확인
arr=(`sudo ls -l /etc/xinetd.d | grep rsync | awk '{print $1,$3,$4}' | grep -v bak`)
if [ "${arr[0]}" == "-rw-------" ] && [ "${arr[1]}" == "root" ] && [ "${arr[2]}" == "root" ]
then
    echo -e "\033[32m"Succeeded"\033[0m - 11./etc/xinetd.d/rsync 권한 및 사용자, 그룹 확인"
else
    echo -e "\033[31m"Failed"\033[0m - 11./etc/xinetd.d/rsync 권한 및 사용자, 그룹 확인"
    exit 9
fi

# 12. /etc/xinetd.d/rsync 사용자 및 그룹 확인 (root), 600 권한 확인
arr=(`ls -l /etc/at.deny | awk '{print $1,$3,$4}' | grep -v bak`)
if [ "${arr[0]}" == "-rw-r-----" ] && [ "${arr[1]}" == "root" ] && [ "${arr[2]}" == "root" ]
then
    echo -e "\033[32m"Succeeded"\033[0m - 11./etc/xinetd.d/rsync 권한 및 사용자, 그룹 확인"
else
    echo -e "\033[31m"Failed"\033[0m - 11./etc/xinetd.d/rsync 권한 및 사용자, 그룹 확인"
    exit 9
fi

# 13. unix_chkpwd.bak 존재 여부 확인
if [ -e /sbin/unix_chkpwd.bak ];
then
    echo -e "\033[32m"Succeeded"\033[0m - 13.unix_chkpwd 백업"
else
    echo -e "\033[31m"Failed"\033[0m - 13.unix_chkpwd 백업"
    exit 9
fi

# 14. at.bak 존재 여부 확인
if [ -e /usr/bin/at.bak ];
then
    echo -e "\033[32m"Succeeded"\033[0m - 14.at.bak 백업"
else
    echo -e "\033[31m"Failed"\033[0m - 14.at.bak 백업"
    exit 9
fi

# 15. newgrp.bak 존재 여부 확인
if [ -e /usr/bin/newgrp.bak ];
then
    echo -e "\033[32m"Succeeded"\033[0m - 15.newgrp.bak 백업"
else
    echo -e "\033[31m"Failed"\033[0m - 15.newgrp.bak 백업"
    exit 9
fi

# 16. /sbin/unix_chkpwd setuid, setgid 설정 여부
if [ "$(ls -l /sbin/unix_chkpwd | awk '{print $1}' | grep -v bak)" == "-rwxr-xr-x" ]
then
    echo -e "\033[32m"Succeeded"\033[0m - 16. /sbin/unix_chkpwd setuid, setgid 설정 여부"
else
    echo -e "\033[31m"Failed"\033[0m - 16. /sbin/unix_chkpwd setuid, setgid 설정 여부"
    exit 9
fi

# 17. /usr/bin/at setuid, setgid 설정 여부
if [ "$(ls -l /usr/bin/at | awk '{print $1}' | grep -v bak)" == "-rwxr-xr-x" ]
then
    echo -e "\033[32m"Succeeded"\033[0m - 17. /usr/bin/at setuid, setgid 설정 여부"
else
    echo -e "\033[31m"Failed"\033[0m - 17. /usr/bin/at setuid, setgid 설정 여부"
    exit 9
fi


# 18. /usr/bin/newgrp setuid, setgid 설정 여부
if [ "$(ls -l /usr/bin/newgrp | awk '{print $1}' | grep -v bak)" == "-rwxr-xr-x" ]
then
    echo -e "\033[32m"Succeeded"\033[0m - 16. /usr/bin/newgrp setuid, setgid 설정 여부"
else
    echo -e "\033[31m"Failed"\033[0m - 16. /usr/bin/newgrp setuid, setgid 설정 여부"
    exit 9
fi

# 19. /etc/pam.d/password-auth.bak 존재 여부 확인
if [ -e /etc/pam.d/password-auth.bak ];
then
    echo -e "\033[32m"Succeeded"\033[0m - 19.password-auth.bak 백업"
else
    echo -e "\033[31m"Failed"\033[0m - 19.password-auth.bak 백업"
    exit 9
fi

# 20. /etc/pam.d/password-auth.bak 존재 여부 확인
if [ -e /etc/pam.d/system-auth.bak ];
then
    echo -e "\033[32m"Succeeded"\033[0m - 20.system-auth.bak 백업"
else
    echo -e "\033[31m"Failed"\033[0m - 20.system-auth.bak 백업"
    exit 9
fi

# 21. /etc/pam.d/password-auth 설정 여부
if [ "$(cat /etc/pam.d/password-auth | grep pam_tally2.so -wc)" == 2 ]
then
    echo -e "\033[32m"Succeeded"\033[0m - 21.password-auth pam_tally2.so 설정"
else
    echo -e "\033[31m"Failed"\033[0m - 21.password-auth pam_tally2.so 설정"
    exit 9
fi

# 22. /etc/pam.d/system-auth 설정 여부
if [ "$(cat /etc/pam.d/system-auth | grep pam_tally2.so -wc)" == 2 ]
then
    echo -e "\033[32m"Succeeded"\033[0m - 22.system-auth pam_tally2.so 설정"
else
    echo -e "\033[31m"Failed"\033[0m - 22.system-auth pam_tally2.so 설정"
    exit 9
fi

# 23. cat /etc/motd 
cat /etc/motd 
if [ -e /etc/motd.bak ];
then
    echo -e "\033[32m"Succeeded"\033[0m - 23./etc/motd 메시지 백업"
else
    echo -e "\033[31m"Failed"\033[0m - 23./etc/motd  메시지 백업"
    exit 9
fi
# 24. cat /etc/issue 
cat /etc/issue
if [ -e /etc/issue ];
then
    echo -e "\033[32m"Succeeded"\033[0m - 23./etc/motd 메시지 백업"
else
    echo -e "\033[31m"Failed"\033[0m - 23./etc/motd  메시지 백업"
    exit 9
fi